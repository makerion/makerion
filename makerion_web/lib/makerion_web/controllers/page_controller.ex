defmodule MakerionWeb.PageController do
  use MakerionWeb, :controller

  def index(conn, _params) do
    render(conn, "index.html")
  end
end
