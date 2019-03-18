defmodule MakerionKiosk.Components.PrinterStatus do
  use Scenic.Component
  alias Scenic.Graph

  import Scenic.Primitives, only: [{:text, 2}, {:text, 3}, {:update_opts, 2}, {:group, 3}]

  @target System.get_env("MIX_TARGET") || "host"

  @system_info """
  MIX_TARGET: #{@target}
  MIX_ENV: #{Mix.env()}
  Scenic version: #{Scenic.version()}
  """

  @iex_note """
  Please note: because Scenic draws over
  the entire screen in Nerves, IEx has
  been routed to the UART pins.
  """

  @graph Graph.build(font_size: 22, font: :roboto_mono)
  |> group(
  fn g ->
    g
    |> text("System")
    |> text(@system_info, translate: {10, 20}, font_size: 18, id: :printer_status_text)
  end,
  t: {10, 30}
  )

  # --------------------------------------------------------
  def init(_, opts) do
    graph =
      @graph
    # |> Graph.modify(:device_list, &update_opts(&1, hidden: @target == "host"))
    |> push_graph()

    Registry.register(Registry.PrinterEvents, :printer_status, [])

    {:ok, graph}
  end

  def verify(data), do: {:ok, data}
  def info, do: ""

  def handle_info({:printer_event, :printer_status, status = %Makerion.PrinterStatus{}}, graph) do
    # Process.send_after(self(), :update_devices, 1000)

    # update the graph
    graph =
      graph
      |> Graph.modify(:printer_status_text, &text(&1, status.state))
      |> push_graph()

    {:noreply, graph}
  end
end
