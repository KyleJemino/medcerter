defmodule Medcerter.Patients.Resolvers.PatientResolver do
  import Medcerter.Patients.Queries.PatientQuery
  alias Medcerter.Repo
  alias Medcerter.Patients.{
    Patient,
    DoctorPatient
  }
  alias Medcerter.Patients.Resolvers.DoctorPatientResolver, as: DPR
  alias Ecto.Multi

  def get_patient(params) when is_map(params) do
    params
    |> query_patient()
    |> Repo.one()
  end

  def get_patient(id, attrs \\ %{}) do
    attrs
    |> Map.put("id", id)
    |> query_patient()
    |> Repo.one()
  end

  def list_patients(params) do
    params
    |> query_patient()
    |> Repo.all()
  end

  def create_patient(attrs) do
    Multi.new()
    |> Multi.insert(:patient, change_create_patient(%Patient{}, attrs))
    |> Multi.insert(:doctor_patient, fn %{patient: patient} ->
      doctor_patient_params = %{
        "patient_id" => patient.id,
        "doctor_id" => Map.get(attrs, "doctor_id")
      }

      DPR.changeset(%DoctorPatient{}, doctor_patient_params)
    end)
    |> Repo.transaction()
  end

  def update_patient(%Patient{} = patient, params) do
    patient
    |> Patient.changeset(params)
    |> Repo.update()
  end

  def change_create_patient(patient, attrs \\ %{}) do
    Patient.create_changeset(patient, attrs)
  end
end
