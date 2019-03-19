defmodule Makerion.Repo.Migrations.CreatePrintFiles do
  use Ecto.Migration

  def change do
    create table(:print_files) do
      add :name, :string
      add :path, :string

      timestamps()
    end

  end
end
