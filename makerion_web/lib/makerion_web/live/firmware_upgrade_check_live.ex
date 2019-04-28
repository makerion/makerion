defmodule MakerionWeb.FirmwareUpgradeCheckLive do
  @moduledoc """
  LiveView component to show version and upgrade information
  """

  use Phoenix.LiveView
  use Phoenix.HTML

  import MakerionWeb.Router.Helpers

  alias MakerionUpdater.{FirmwareManager, FirmwareStatus}
  alias MakerionWeb.FirmwareView

  def render(assigns) do
    ~L"""
    <%= if assigns[:firmware_status] do %>
      Version <%= FirmwareView.current_version(@firmware_status) %>
      <%= if FirmwareStatus.update_available?(@firmware_status) do %>
        <%= link "Upgrade Available!", to: firmware_path(MakerionWeb.Endpoint, :index) %>
      <% end %>
    <% end %>
    """
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

  def handle_info({:firmware_event, %FirmwareStatus{} = firmware_status}, socket) do
    {:noreply, assign(socket, firmware_status: firmware_status)}
  end
end
