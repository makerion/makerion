defmodule MakerionWeb.PrintFileLive.Index do
  @moduledoc """
  LiveView for print file list
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  alias Makerion.{Print, PrinterPoller}
  alias MakerionWeb.PrintFileView
  alias Moddity.PrinterStatus

  def render(assigns) do
    PrintFileView.render("index.html", assigns)
  end

  def mount(_user, socket) do
    Print.subscribe()
    Registry.register(Registry.PrinterEvents, :printer_status, [])
    {:ok, fetch(socket)}
  end

  def handle_info({:print_file, _}, socket) do
    socket =
      socket
      |> assign(printer_idle?: false)
      |> fetch()
    {:noreply, socket}
  end

  def handle_info({:printer_event, :printer_status, %PrinterStatus{idle?: idle}}, socket) do
    {:noreply, assign(socket, printer_idle?: idle)}
  end

  def handle_event("delete_file", id, socket) do
    file = Print.get_print_file!(id)
    Print.delete_print_file(file)

    {:noreply, socket}
  end

  def handle_event("print_file", id, socket) do
    file = Print.get_print_file!(id)
    print_file_path = Path.join(Print.print_file_path, file.path)
    PrinterPoller.send_gcode(print_file_path)

    {:noreply, socket}
  end

  defp fetch(socket) do
    assign(socket, print_files: Print.list_print_files())
  end
end
