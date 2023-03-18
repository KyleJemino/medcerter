defmodule Medcerter.Repo.Migrations.AddClinicsTable do
  use Ecto.Migration

  def change do
    create table(:clinics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :name, :string, null: false
      add :address, :string
      add :archived_at, :utc_datetime
      timestamps()
    end

    create table(:doctor_clinics, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :clinic_id, references(:clinics, type: :binary_id, on_delete: :nothing)
      add :doctor_id, references(:doctors, type: :binary_id, on_delete: :nothing)
      add :role, :string
      add :archived_at, :utc_datetime
      timestamps()
    end

    create index(:doctor_clinics, [:clinic_id])
    create index(:doctor_clinics, [:doctor_id])
  end
end
