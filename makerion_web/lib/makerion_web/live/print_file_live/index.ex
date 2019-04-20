defmodule MakerionWeb.PrintFileLive.Index do
  @moduledoc """
  LiveView for print file list
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  alias Makerion.Print
  alias MakerionWeb.PrintFileView
  alias Moddity.{Driver, PrinterStatus}

  def render(assigns) do
    PrintFileView.render("index.html", assigns)
  end

  def mount(_user, socket) do
    Print.subscribe()
    Driver.subscribe()
    case Driver.get_status() do
      {:ok, %PrinterStatus{idle?: idle}} ->
        {:ok, fetch(assign(socket, :printer_idle?, idle))}
      _ ->
        {:ok, fetch(socket)}
    end
  end

  def handle_info({:print_file, _}, socket) do
    socket =
      socket
      |> assign(printer_idle?: false)
      |> fetch()
    {:noreply, socket}
  end

  def handle_info({:printer_status_event, %PrinterStatus{idle?: idle}}, socket) do
    {:noreply, assign(socket, printer_idle?: idle)}
  end

  def handle_event("delete_file", id, socket) do
    file = Print.get_print_file!(id)
    Print.delete_print_file(file)

    {:noreply, socket}
  end

  def handle_event("print_file", id, socket) do
    file = Print.get_print_file!(id)
    :ok = Print.start_print(file)

    {:noreply, socket}
  end

  defp fetch(socket) do
    assign(socket, print_files: Print.list_print_files())
  end
end
