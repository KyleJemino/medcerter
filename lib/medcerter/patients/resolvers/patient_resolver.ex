defmodule Medcerter.Patients.Resolvers.PatientResolver do
  import Medcerter.Patients.Queries.PatientQuery
  alias Medcerter.Repo
  alias Medcerter.Patients.Patient

  def get_patient(id) do
    %{"id" => id}
    |> query_patient()
    |> Repo.one()
  end

  def build_patient_query(params \\ %{}), do: query_patient(params)

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

  def change_create_patient(patient, attrs \\ %{}) do
    Patient.create_changeset(patient, attrs)
  end
end
