defmodule MakerionKiosk.Components do
  alias MakerionKiosk.Components.PrinterStatus
  alias Scenic.Graph

  def printer_status(%Graph{} = g, data, options) do
    add_to_graph(g, PrinterStatus, data, options)
  end

  defp add_to_graph(%Graph{} = g, mod, data, options) do
    mod.verify!(data)
    mod.add_to_graph(g, data, options)
  end
end
