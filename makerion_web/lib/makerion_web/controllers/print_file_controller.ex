defmodule MakerionWeb.PrintFileController do
  use MakerionWeb, :controller

  alias Makerion.Print
  alias MakerionWeb.ErrorHelpers

  def create(conn, %{"print_file" => print_file_params}) do
    file = print_file_params["file"]
    %{tempfile: file.path, path: file.filename, name: Path.basename(file.filename, ".gcode")}
    |> Print.create_print_file()
    |> case do
         {:ok, _print_file} ->
           json(conn, %{status: "success"})

         {:error, %Ecto.Changeset{} = changeset} ->
           json(conn, %{status: "error", errors: traverse_errors(changeset)})
       end
  end

  defp traverse_errors(changeset) do
    Ecto.Changeset.traverse_errors(changeset, &ErrorHelpers.translate_error/1)
  end
end
