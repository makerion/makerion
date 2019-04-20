defmodule Makerion.Print.PrintFile do
  @moduledoc """
  Contains schema and changeset information for print_files, which represent a gcode file and metadata
  """

  use Ecto.Schema
  import Ecto.Changeset

  schema "print_files" do
    field :tempfile, :string, virtual: true
    field :name, :string
    field :path, :string
    field :last_printed_at, :utc_datetime

    timestamps()
  end

  @doc false
  def create_changeset(print_file, attrs) do
    print_file
    |> cast(attrs, [:name, :path, :tempfile])
    |> unsafe_validate_unique(:name, Makerion.Repo)
    |> unsafe_validate_unique(:path, Makerion.Repo)
    |> validate_required([:name, :path, :tempfile])
  end
end
