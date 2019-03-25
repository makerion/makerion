defmodule MakerionWeb.PrintFileLive.Index do
  use Phoenix.LiveView
  use Phoenix.HTML

  alias Makerion.{Print, PrinterPoller}
  alias MakerionWeb.PrintFileView

  def render(assigns) do
    PrintFileView.render("index.html", assigns)
  end

  def mount(_user, socket) do
    Print.subscribe()
    {:ok, fetch(socket)}
  end

  def handle_info({:print_file, _}, socket) do
    {:noreply, fetch(socket)}
  end

  def handle_event("delete_file", id, socket) do
    file = Print.get_print_file!(id)
    Print.delete_print_file(file)

    {:noreply, socket}
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
