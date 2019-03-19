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
    |> validate_required([:name, :path])
  end
end
