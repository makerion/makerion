defmodule Makerion.Print do
  @moduledoc """
  The Print context.
  """

  import Ecto.Query, warn: false

  alias Ecto.Changeset
  alias Makerion.Repo
  alias Makerion.Print.PrintFile

  @doc """
  Returns the list of print_files.

  ## Examples

      iex> list_print_files()
      [%PrintFile{}, ...]

  """
  def list_print_files do
    Repo.all(PrintFile)
  end

  @doc """
  Gets a single print_file.

  Raises `Ecto.NoResultsError` if the Print file does not exist.

  ## Examples

      iex> get_print_file!(123)
      %PrintFile{}

      iex> get_print_file!(456)
      ** (Ecto.NoResultsError)

  """
  def get_print_file!(id), do: Repo.get!(PrintFile, id)

  @doc """
  Creates a print_file.

  ## Examples

      iex> create_print_file(%{field: value})
      {:ok, %PrintFile{}}

      iex> create_print_file(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_print_file(attrs \\ %{}) do
    %PrintFile{}
    |> PrintFile.changeset(Map.put(attrs, "name", String.replace(attrs["file"].filename, ".gcode", "")))
    |> Repo.insert()
    |> case do
         {:ok, print_file} ->
           upload = attrs["file"]
           File.mkdir(print_file_path())
           File.cp(upload.path, Path.join(print_file_path(), upload.filename))
           {:ok, print_file}
         error -> error
       end
  end

  def print_file_path do
    Application.get_env(:makerion, :print_file_path)
  end

  @doc """
  Updates a print_file.

  ## Examples

      iex> update_print_file(print_file, %{field: new_value})
      {:ok, %PrintFile{}}

      iex> update_print_file(print_file, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_print_file(%PrintFile{} = print_file, attrs) do
    print_file
    |> PrintFile.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a PrintFile.

  ## Examples

      iex> delete_print_file(print_file)
      {:ok, %PrintFile{}}

      iex> delete_print_file(print_file)
      {:error, %Ecto.Changeset{}}

  """
  def delete_print_file(%PrintFile{} = print_file) do
    Repo.delete(print_file)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking print_file changes.

  ## Examples

      iex> change_print_file(print_file)
      %Ecto.Changeset{source: %PrintFile{}}

  """
  def change_print_file(%PrintFile{} = print_file) do
    PrintFile.changeset(print_file, %{})
  end
end
