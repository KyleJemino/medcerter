defmodule Medcerter.Patients.Queries.PatientQuery do
  import Ecto.Query
  alias Medcerter.Patients.Patient

  def query_patient(params) do
    query_by(Patient, params)
  end

  defp query_by(query, %{"clinic_id" => clinic_id} = params) do
    query
    |> where([q], q.clinic_id == ^clinic_id)
    |> query_by(Map.delete(params, "clinic_id"))
  end

  use Medcerter, :basic_queries
end
