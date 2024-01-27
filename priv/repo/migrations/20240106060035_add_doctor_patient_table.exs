defmodule Medcerter.Repo.Migrations.AddDoctorPatientTable do
  use Ecto.Migration

  alias Medcerter.{
    Clinics,
    Patients
  }

  alias Clinics.DoctorClinic

  def up do
    create table(:doctor_patients, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :doctor_id, references(:doctors, type: :binary_id, on_delete: :nothing), null: false
      add :patient_id, references(:patients, type: :binary_id, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:doctor_patients, [:doctor_id])
    create index(:doctor_patients, [:patient_id])
  end

  def down do
    drop_if_exists index(:doctor_patients, [:doctor_id])
    drop_if_exists index(:doctor_patients, [:patient_id])
    drop_if_exists table(:doctor_patients)
  end
end
