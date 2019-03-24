defmodule MakerionWeb.PrintFileController do
  use MakerionWeb, :controller

  import MakerionWeb.Router.Helpers

  alias Makerion.Print
  alias Makerion.Print.PrintFile
  alias MakerionWeb.ErrorHelpers

  def index(conn, _params) do
    print_files = Print.list_print_files()
    render(conn, "index.html", print_files: print_files)
  end

  def new(conn, _params) do
    changeset = Print.change_print_file(%PrintFile{})

    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"print_file" => print_file_params} = params) do
    # IO.inspect print_file_params

  #   %{
  #     "file" => %Plug.Upload{
  #   content_type: "application/octet-stream",
  #   filename: "Turn Table - 1 piece.gcode",
  #   path: "/var/folders/tc/306s6wl55_j_5slh73fgz9vh0000gn/T//plug-1552/multipart-1552962246-505013590217792-1"
  # },
  #     "name" => "Turn Table"
  #   }

    print_file_params
    |> Map.put("path", print_file_params["file"].filename)
    |> Print.create_print_file()
    |> case do
         {:ok, print_file} ->
           json(conn, %{status: "success"})

         {:error, %Ecto.Changeset{} = changeset} ->
           json(conn, %{status: "error", errors: traverse_errors(changeset)})
       end
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
  end
end
