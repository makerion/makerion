defmodule MakerionWeb.PrinterStatusLive.Show do
  @moduledoc """
  LiveView component to show printer status
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  alias MakerionWeb.PrinterStatusView
  alias Moddity.{Driver, PrinterStatus}

  def render(assigns) do
    PrinterStatusView.render("show.html", assigns)
  end

  def mount(_user, socket) do
    Driver.subscribe()
    case Driver.get_status() do
      {:ok, %PrinterStatus{} = printer_status} ->
        {:ok, assign_printer_status(socket, printer_status)}
      _ ->
        {:ok, socket}
    end
  end

  def handle_info({:printer_status_event, printer_status}, socket) do
    {:noreply, assign_printer_status(socket, printer_status)}
  end

  defp assign_printer_status(socket, %PrinterStatus{} = printer_status) do
    assign(socket, printer_status: printer_status)
  end
end
