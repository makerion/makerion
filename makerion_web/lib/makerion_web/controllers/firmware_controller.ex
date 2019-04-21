defmodule MakerionWeb.FirmwareController do
  use MakerionWeb, :controller

  def index(conn, _params) do
    render(conn, %{update_available: MakerionUpdater.update_available?})
  end

  def create(conn, _params) do
    if MakerionUpdater.update_available? do
      MakerionUpdater.do_update!
    end
    render(conn, "index.html", %{update_available: MakerionUpdater.update_available?})
  end
end
