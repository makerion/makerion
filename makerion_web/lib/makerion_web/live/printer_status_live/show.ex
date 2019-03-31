defmodule MakerionWeb.PrinterStatusLive.Show do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Makerion.PrinterPoller
  alias MakerionWeb.PrinterStatusView

  def render(assigns) do
    PrinterStatusView.render("show.html", assigns)
  end

  def mount(_user, socket) do
    Registry.register(Registry.PrinterEvents, :printer_status, [])
    {:ok, socket}
  end

  def handle_event("Load Filament", _, socket) do
    PrinterPoller.load_filament()
    {:noreply, socket}
  end

  def handle_event("Unload Filament", _, socket) do
    PrinterPoller.unload_filament()
    {:noreply, socket}
  end

  def handle_info({:printer_event, :printer_status, event_data}, socket) do
    {:noreply, assign(socket, printer_status: event_data)}
  end
end
