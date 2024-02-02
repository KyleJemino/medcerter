defmodule Medcerter.Repo.Migrations.AddArchivedAtToPrescription do
  use Ecto.Migration

  def change do
    alter table(:prescriptions) do
      add :archived_at, :utc_datetime
    end
  end
end
