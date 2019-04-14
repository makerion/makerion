defmodule MakerionKiosk.Scene.SysInfo do
  use Scenic.Scene
  alias Scenic.Graph

  import MakerionKiosk.Components, only: [{:printer_status, 3}]

  @graph Graph.build()
  |> printer_status("", id: :printer_status)

  def init(_, opts) do
    {:ok, _info} = Scenic.ViewPort.info(opts[:viewport])

    graph =
      @graph
      |> push_graph()

    {:ok, graph}
  end
end
