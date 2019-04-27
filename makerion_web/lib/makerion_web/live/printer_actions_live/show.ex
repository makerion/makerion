defmodule MakerionWeb.PrinterActionsLive.Show do
  @moduledoc """
  LiveView component to show printer actions
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  alias MakerionWeb.PrinterActionView
  alias Moddity.{Driver, PrinterStatus}

  def render(assigns) do
    PrinterActionView.render("show.html", assigns)
  end

  def mount(_user, socket) do
    Driver.subscribe()
    case Driver.get_status() do
      {:ok, %PrinterStatus{} = printer_status} ->
        {:ok, assign_printer_status(socket, printer_status)}
      _ ->
        {:ok, assign(socket, printer_idle?: false)}
    end
  end

  def handle_event("Load Filament", _, socket) do
    Driver.load_filament()
    {:noreply, socket}
  end

  def handle_event("Unload Filament", _, socket) do
    Driver.unload_filament()
    {:noreply, socket}
  end

  def handle_info({:printer_status_event, printer_status}, socket) do
    {:noreply, assign_printer_status(socket, printer_status)}
  end

  defp assign_printer_status(socket, %PrinterStatus{idle?: idle}) do
    assign(socket, printer_idle?: idle)
  end
end
