defmodule MakerionKiosk.Components.PrinterStatus do
  @moduledoc """
  Component to show the current printer status and other useful info
  """

  use Scenic.Component

  alias Moddity.{Driver, PrinterStatus}
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:text, 2}, {:text, 3}, {:group, 3}]

  @graph Graph.build(font_size: 22, font: :roboto_mono)
  |> group(
  fn g ->
    g
    |> text("System")
    |> text("IP Address", translate: {10, 20}, id: :ip_address)
    |> text("", translate: {0, 40}, font_size: 18, id: :printer_status_text)
  end,
  t: {10, 30}
  )

  # --------------------------------------------------------
  def init(_, _opts) do
    Driver.subscribe()
    Process.send_after(self(), :update_ip, 5_000)

    {:ok, @graph, push: @graph}
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

          Process.send_after(self(), :update_ip, 120_000)
          {:noreply, graph, push: graph}

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

    {:noreply, graph, push: graph}
  end
end
