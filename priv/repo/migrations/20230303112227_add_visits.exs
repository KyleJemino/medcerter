defmodule Medcerter.Repo.Migrations.AddVisits do
  use Ecto.Migration

  def change do
    create table(:visits, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :date, :utc_datetime
      add :patient_id, references(:patients, type: :binary_id, on_delete: :nothing)
      add :doctor_id, references(:doctors, type: :binary_id, on_delete: :nothing)
      add :history, :text
      add :archived_at, :utc_datetime

      timestamps()
    end

    create index(:visits, [:patient_id])
    create index(:visits, [:doctor_id])
  end
end
