defmodule Medcerter.Patients.Queries.DoctorPatientQuery do
  import Ecto.Query
  alias Medcerter.Patients.DoctorPatient

  def query_doctor_patient(params) do
    query_by(Patient, params)
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> where([q], q.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(query, %{"patient_id" => patient_id} = params) do
    query
    |> where([q], q.patient_id == ^patient_id)
    |> query_by(Map.delete(params, "patient_id"))
  end

  use Medcerter, :basic_queries
end
