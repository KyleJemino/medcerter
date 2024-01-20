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

    flush()

    clinic_preload_query = Clinics.query_clinic(%{
      "preload" => [:doctors]
    })

    patient_params = %{
      "preload" => [
        clinic: clinic_preload_query
      ]
    }

    ## create doctor_clinics
    doctor_patient_entries =
      patient_params
      |> Patients.list_patients()
      |> Enum.flat_map(fn patient -> 
        Enum.map(patient.clinic.doctors, fn doctor ->
          now = NaiveDateTime.utc_now(:second)
          %{
            id: Ecto.UUID.generate() |> Ecto.UUID.dump!(),
            patient_id: Ecto.UUID.dump!(patient.id),
            doctor_id: Ecto.UUID.dump!(doctor.id),
            inserted_at: now,
            updated_at: now
          }
        end)
      end)

    execute(fn -> repo().insert_all("doctor_patients", doctor_patient_entries) end)
  end

  def down do
    drop_if_exists index(:doctor_patients, [:doctor_id])
    drop_if_exists index(:doctor_patients, [:patient_id])
    drop_if_exists table(:doctor_patients)
  end
end
