defmodule Makerion.Repo.Migrations.AddLastPrintedAtToPrintFiles do
  use Ecto.Migration

  def change do
    alter table(:print_files) do
      add :last_printed_at, :utc_datetime
    end
  end
end
