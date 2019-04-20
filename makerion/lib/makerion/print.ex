defmodule Makerion.Print do
  @moduledoc """
  The Print context.
  """

  import Ecto.Changeset
  import Ecto.Query, warn: false

  alias Makerion.Print.PrintFile
  alias Makerion.Repo
  alias Moddity.Driver

  def subscribe do
    Registry.register(Registry.MakerionPrintEvents, :print_file, [])
  end

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
  """
  def create_print_file(attrs \\ %{}) do
    %PrintFile{}
    |> PrintFile.create_changeset(attrs)
    |> Repo.insert()
    |> case do
         {:ok, print_file} ->
           File.mkdir(print_file_path())
           File.cp(print_file.tempfile, Path.join(print_file_path(), print_file.path))
           notify_subscribers(:print_file, {:print_file, :added})
           {:ok, %{print_file | tempfile: nil}}
         error -> error
       end
  end

  def print_file_path do
    Application.get_env(:makerion, :print_file_path)
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
    print_file
    |> Repo.delete()
    |> case do
         {:ok, response} ->
           File.rm(Path.join(print_file_path(), print_file.path))
           notify_subscribers(:print_file, {:print_file, :deleted})
           {:ok, response}
         error -> error
       end

  end

  def start_print(%PrintFile{} = print_file) do
    with print_file_path <- Path.join(print_file_path(), print_file.path),
         :ok <- Driver.send_gcode(print_file_path),
         {:ok, _print_file} <- Repo.update(change(print_file, last_printed_at: DateTime.utc_now())) do

      notify_subscribers(:print_file, {:print_file, :updated})
      :ok
    else
      error -> error
    end
  end

  defp notify_subscribers(topic, message) do
    Registry.dispatch(Registry.MakerionPrintEvents, topic, fn entries ->
      for {pid, _} <- entries, do: send(pid, message)
    end)
  end
end
