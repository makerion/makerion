defmodule Makerion.Repo.Migrations.CreatePrintFiles do
  use Ecto.Migration

  def change do
    create table(:print_files) do
      add :name, :string
      add :path, :string

      timestamps()
    end

    create unique_index(:print_files, [:name])
    create unique_index(:print_files, [:path])
  end
end
