defmodule Medcerter.Repo.Migrations.CreatePatients do
  use Ecto.Migration

  def change do
    create table(:patients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string, null: false
      add :last_name, :string, null: false
      add :middle_name, :string
      add :birth_date, :date, null: false
      add :sex, :string, null: false
      add :archived_at, :utc_datetime
      add :doctor_id, references(:doctors, on_delete: :nothing, type: :binary_id), null: false
      add :family_history, :text
      add :allergies, {:array, :string}

      timestamps()
    end

    create index(:patients, [:doctor_id])
  end
end
