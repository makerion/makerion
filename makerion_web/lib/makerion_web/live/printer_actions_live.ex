defmodule MakerionWeb.PrinterActionsLive do
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
        {:ok, assign(assign_printer_status(socket, printer_status), show_advanced: false)}
      _ ->
        {:ok, assign(socket, firmware_updating?: false, printer_idle?: false, show_advanced: false)}
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

  def handle_event("Reset Printer", _, socket) do
    Driver.reset_printer()
    {:noreply, socket}
  end

  def handle_event("Pause Printer", _, socket) do
    Driver.pause_printer()
    {:noreply, socket}
  end

  def handle_event("Resume Printer", _, socket) do
    Driver.resume_printer()
    {:noreply, socket}
  end

  def handle_event("Abort Print", _, socket) do
    Driver.abort_print()
    {:noreply, socket}
  end

  def handle_event("Update Firmware", _, socket) do
    Driver.update_firmware("https://raw.githubusercontent.com/tripflex/MOD-t/master/firmware/0.14.0/firmware_modt_override.dfu", "beb6a02c4f5f4f69a4a8025f2f8d5e68d34a43a9bc0224a5f42592edf6dba67c")
    {:noreply, socket}
  end

  def handle_event("Toggle Advanced", _, socket) do
    {:noreply, assign(socket, show_advanced: !socket.assigns.show_advanced)}
  end

  def handle_info({:printer_status_event, printer_status}, socket) do
    {:noreply, assign_printer_status(socket, printer_status)}
  end

  defp assign_printer_status(socket, %PrinterStatus{idle?: idle, firmware_updating?: firmware_updating}) do
    assign(socket, printer_idle?: idle, firmware_updating?: firmware_updating)
  end
end
