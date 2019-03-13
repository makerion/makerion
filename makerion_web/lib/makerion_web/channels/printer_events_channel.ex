defmodule MakerionWeb.PrinterEventsChannel do
  use Phoenix.Channel

  def join("printer_events", _message, socket) do
    {:ok, socket}
  end
end
