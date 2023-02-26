defmodule Medcerter.Patients.PatientQuery do
  import Ecto.Query
  alias Medcerter.Patients.Patient
  alias Medcerter.Accounts.Doctor

  def query_patient(params) do
    query_by(Patient, params)
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> where([q], q.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(query, _params), do: query
end
