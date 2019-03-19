defmodule MakerionWeb.PrintFileController do
  use MakerionWeb, :controller

  alias Makerion.Print

  def index(conn, _params) do
    print_files = Print.list_print_files()
    render(conn, "index.html", print_files: print_files)
  end
end
