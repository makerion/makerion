defmodule MakerionWeb.PrinterEventHandler do
  @moduledoc """
  Event handler for rebroadcasting printer status events from the backend
  """

  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  def init([]) do
    Registry.register(Registry.PrinterEvents, :printer_status, [])
    {:ok, []}
  end

  def handle_info({:printer_event, :printer_status, event_data}, state) do
    MakerionWeb.Endpoint.broadcast("printer_events", "printer_status", event_data)
    {:noreply, state}
  end
end
