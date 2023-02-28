defmodule Medcerter.Patients.Queries.PatientQuery do
  import Ecto.Query
  alias Medcerter.Patients.Patient

  def query_patient(params) do
    query_by(Patient, params)
  end

  use Medcerter, :basic_queries

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> where([q], q.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(query, _params), do: query
end