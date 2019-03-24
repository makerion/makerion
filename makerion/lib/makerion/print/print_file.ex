defmodule Makerion.Print.PrintFile do
  use Ecto.Schema
  import Ecto.Changeset

  schema "print_files" do
    field :name, :string
    field :path, :string

    timestamps()
  end

  @doc false
  def changeset(print_file, attrs) do
    print_file
    |> cast(attrs, [:name, :path])
    |> unsafe_validate_unique(:name, Makerion.Repo)
    |> unsafe_validate_unique(:path, Makerion.Repo)
    |> validate_required([:path])
  end
end
