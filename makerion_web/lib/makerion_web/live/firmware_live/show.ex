defmodule MakerionWeb.FirmwareLive.Show do
  @moduledoc """
  LiveView component to show printer status
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  alias MakerionUpdater.{FirmwareManager, FirmwareStatus}
  alias MakerionWeb.FirmwareView

  def render(assigns) do
    FirmwareView.render("show.html", assigns)
  end

  def mount(_user, socket) do
    FirmwareManager.subscribe()
    case FirmwareManager.do_check() do
      {:ok, %FirmwareStatus{} = firmware_status} ->
        {:ok, assign(socket, firmware_status: firmware_status)}
      _ ->
        {:ok, socket}
    end
  end

  def handle_event("Upgrade Firmware", _, socket) do
    FirmwareManager.do_update!()
    {:noreply, socket}
  end

  def handle_info({:firmware_event, %FirmwareStatus{} = firmware_status}, socket) do
    {:noreply, assign(socket, firmware_status: firmware_status)}
  end
end
