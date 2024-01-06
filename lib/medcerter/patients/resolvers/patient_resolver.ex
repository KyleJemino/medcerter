defmodule Medcerter.Patients.Resolvers.PatientResolver do
  import Medcerter.Patients.Queries.PatientQuery
  alias Medcerter.Repo
  alias Medcerter.Patients.Patient

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

  def create_patient(params) do
    %Patient{}
    |> Patient.create_changeset(params)
    |> Repo.insert()
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
