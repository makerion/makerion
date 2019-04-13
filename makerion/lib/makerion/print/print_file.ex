defmodule Makerion.Print.PrintFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "print_files" do
    field :tempfile, :string, virtual: true
    field :name, :string
    field :path, :string

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
