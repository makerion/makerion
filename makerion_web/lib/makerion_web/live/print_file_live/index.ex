defmodule MakerionWeb.PrintFileLive.Index do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Makerion.{Print, PrinterPoller}
  alias MakerionWeb.PrintFileView

  def render(assigns) do
    PrintFileView.render("index.html", assigns)
  end

  def mount(_user, socket) do
    {:ok, fetch(socket)}
  end

  def handle_info({:printer_event, :printer_status, event_data}, socket) do
    {:noreply, assign(socket, printer_status: event_data)}
  end

  def handle_event("print_file", id, socket) do
    file = Print.get_print_file!(id)
    print_file_path = Path.join(Print.print_file_path, file.path)
    IO.inspect print_file_path
    PrinterPoller.send_gcode(print_file_path)

    {:noreply, socket}
  end

  defp fetch(socket) do
    assign(socket, print_files: Print.list_print_files())
  end
end
