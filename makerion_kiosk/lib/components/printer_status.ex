defmodule MakerionKiosk.Components.PrinterStatus do
  @moduledoc """
  Component to show the current printer status and other useful info
  """

  use Scenic.Component

  alias Moddity.{Driver, PrinterStatus}
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:text, 2}, {:text, 3}, {:group, 3}]

  @target System.get_env("MIX_TARGET") || "host"

  @system_info """
  MIX_TARGET: #{@target}
  MIX_ENV: #{Mix.env()}
  Scenic version: #{Scenic.version()}
  """

  @graph Graph.build(font_size: 22, font: :roboto_mono)
  |> group(
  fn g ->
    g
    |> text("System")
    |> text("IP Address", translate: {10, 20}, id: :ip_address)
    |> text(@system_info, translate: {0, 40}, font_size: 18, id: :printer_status_text)
  end,
  t: {10, 30}
  )

  # --------------------------------------------------------
  def init(_, _opts) do
    graph =
      @graph
    # |> Graph.modify(:device_list, &update_opts(&1, hidden: @target == "host"))
    |> push_graph()

    Driver.subscribe()
    Process.send_after(self(), :update_ip, 5_000)

    {:ok, graph}
  end

  def verify(data), do: {:ok, data}
  def info, do: ""

  def handle_info(:update_ip, graph) do

    nerves_networkinterface = Application.get_env(:makerion_kiosk, :nerves_networkinterface)
    if nerves_networkinterface do
      case nerves_networkinterface.settings "wlan0" do
        {:ok, %{ipv4_address: ipv4_address}} when ipv4_address != <<>> ->
          graph =
            graph
            |> Graph.modify(:ip_address, &text(&1, "IP Address #{ipv4_address}"))
            |> push_graph()

          Process.send_after(self(), :update_ip, 120_000)
          {:noreply, graph}

        _ ->
          Process.send_after(self(), :update_ip, 5_000)
          {:noreply, graph}
      end
    else
      {:noreply, graph}
    end
  end

  def handle_info({:printer_status_event, status = %PrinterStatus{}}, graph) do
    # Process.send_after(self(), :update_devices, 1000)

    # update the graph
    graph =
      graph
      |> Graph.modify(:printer_status_text, &text(&1, status.state_friendly))
      |> push_graph()

    {:noreply, graph}
  end
end
