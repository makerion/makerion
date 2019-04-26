defmodule MakerionUpdater.FirmwareManager do
  @moduledoc """
  Manages checking and applying firmware updates
  """

  use GenServer

  require Logger

  alias MakerionUpdater.GitHubReleaseClient
  alias MakerionUpdater.FirmwareManager.State
  alias MakerionUpdater.FirmwareStatus

  @version_metadata Application.get_env(:makerion_updater, :version_metadata)
  @runtime Application.get_env(:makerion_updater, :runtime)
  @remote_release_client GitHubReleaseClient
  @successful_check_interval 28_800_000
  @failed_check_interval 1_800_000

  defmodule State do
    @moduledoc false
    defstruct firmware_status: nil,
      remote_release_client: nil,
      runtime: nil,
      version_metadata: nil
  end

  def subscribe do
    Registry.register(Registry.MakerionFirmwareEvents, :firmware_event, [])
  end

  def start_link(opts) do
    name = Keyword.get(opts, :name, __MODULE__)
    GenServer.start_link(__MODULE__, opts, name: name)
  end

  def init(opts) do
    version_metadata = Keyword.get(opts, :version_metadata, @version_metadata)
    remote_release_client = Keyword.get(opts, :remote_release_client, @remote_release_client)
    runtime = Keyword.get(opts, :runtime, @runtime)
    poll = Keyword.get(opts, :poll, true)
    delay_before_first_poll = Keyword.get(opts, :delay_before_first_poll, 6_000)

    if poll do
      Process.send_after(self(), :do_check, delay_before_first_poll)
    end
    {:ok, %State{version_metadata: version_metadata, remote_release_client: remote_release_client, runtime: runtime}}
  end

  def update_available?(pid \\ __MODULE__) do
    case GenServer.call(pid, :do_check) do
      {:ok, %FirmwareStatus{} = status} -> FirmwareStatus.update_available?(status)
      _ -> false
    end
  end

  def do_check(pid \\ __MODULE__) do
    GenServer.call(pid, :do_check)
  end

  def do_update!(pid \\ __MODULE__) do
    GenServer.call(pid, :do_update)
  end

  def handle_call(:do_check, _sender, %{firmware_status: nil} = state) do
    case FirmwareStatus.check(state.version_metadata, state.remote_release_client) do
      {:ok, firmware_status} ->
        {:reply, {:ok, firmware_status}, %{state | firmware_status: firmware_status}}

      error ->
        {:reply, error, state}
    end
  end

  def handle_call(:do_check, _sender, %{firmware_status: firmware_status} = state) do
    {:reply, {:ok, firmware_status}, state}
  end

  def handle_call(:do_update, _sender, %{firmware_status: nil} = state) do
    {:reply, {:error, "No firmware status"}, state}
  end

  def handle_call(:do_update, _sender, state) do
    %FirmwareStatus{latest_version: latest_version, target_platform: target_platform} = state.firmware_status

    Task.async(fn ->
      {:firmware_fetch, state.remote_release_client.fetch_firmware(latest_version, target_platform)}
    end)

    firmware_status = FirmwareStatus.set_action(state.firmware_status, :downloading)
    notify_subscribers({:firmware_event, firmware_status})
    {:reply, :ok, %{state | firmware_status: firmware_status}}
  end

  def handle_info({_task, {:firmware_fetch, {:ok, firmware_file}}}, state) do

    Task.async(fn ->
      case  state.runtime.cmd("fwup", [firmware_file, "-t", "upgrade", "-d", "/dev/rootdisk0"], :warn) do
        {_, 0} ->
          {:firmware_upgrade, :ok}
        error ->
          {:firmware_upgrade, error}
      end
    end)

    firmware_status = FirmwareStatus.set_action(state.firmware_status, :upgrading)
    notify_subscribers({:firmware_event, firmware_status})
    {:noreply, %{state | firmware_status: firmware_status}}
  end

  def handle_info({_task, {:firmware_upgrade, :ok}}, state) do
    firmware_status = FirmwareStatus.set_action(state.firmware_status, :rebooting)
    notify_subscribers({:firmware_event, firmware_status})

    Task.async(fn ->
      :ok = state.runtime.reboot()
      :firmware_rebooting
    end)

    {:noreply, %{state | firmware_status: firmware_status}}
  end

  def handle_info({_task, :firmware_rebooting}, state), do: {:noreply, state}

  def handle_info({:DOWN, _task, :process, _pid, :normal}, state), do: {:noreply, state}

  def handle_info(:do_check, state) do
    case FirmwareStatus.check(state.version_metadata, state.remote_release_client) do
      {:ok, firmware_status} ->
        new_state = %{state | firmware_status: firmware_status}
        notify_subscribers({:firmware_event, firmware_status})
        Process.send_after(self(), :do_check, @successful_check_interval)

        {:noreply, new_state}
      _ ->
        Process.send_after(self(), :do_check, @failed_check_interval)

        {:noreply, state}
    end
  end

  defp notify_subscribers(message) do
    Registry.dispatch(Registry.MakerionFirmwareEvents, :firmware_event, fn entries ->
      for {pid, _} <- entries, do: send(pid, message)
    end)
  end
end
