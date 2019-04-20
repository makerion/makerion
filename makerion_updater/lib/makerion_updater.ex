defmodule MakerionUpdater do
  @moduledoc """
  Documentation for MakerionUpdater.
  """

  require Logger

  alias MakerionUpdater.GitHubReleaseClient

  @remote_release_client GitHubReleaseClient
  @runtime Application.get_env(:makerion_updater, :runtime)
  @version_metadata Application.get_env(:makerion_updater, :version_metadata)

  @doc """
  Checks current version metadata against a remote release manager to see if an update is available
  """
  def update_available?(version_metadata \\ @version_metadata, remote_release_client \\ @remote_release_client) do
    with {:ok, current_version} <- current_version(version_metadata),
         {:ok, latest_version} <- latest_version(remote_release_client),
         :lt <- Version.compare(current_version, latest_version) do
      true
    else
      _ -> false
    end
  end

  def do_update!(version_metadata \\ @version_metadata, remote_release_client \\ @remote_release_client) do
    with {:ok, latest_version} <- latest_version(remote_release_client),
         target_board <- version_metadata.get_active("nerves_fw_platform"),
         {:ok, firmware_file} <- remote_release_client.fetch_firmware(latest_version, target_board),
         {_, 0} <- @runtime.cmd("fwup", [firmware_file, "-t", "upgrade", "-d", "/dev/rootdisk0"], :warn) do

      :ok
    else
      error ->
        Logger.error "Could not update firmware: #{inspect error}"
        error
    end
  end

  defp current_version(version_metadata) do
    Version.parse(version_metadata.get_active("nerves_fw_version"))
  end

  defp latest_version(remote_release_client) do
    Version.parse(remote_release_client.get_latest_version())
  end
end
