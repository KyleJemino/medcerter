defmodule Medcerter.Visits.Queries.VisitQuery do
  import Ecto.Query
  alias Medcerter.Visits.Visit

  def query_visit(params) do
    query_by(Visit, params)
  end

  use Medcerter, :basic_queries

  defp query_by(query, %{"patient_id"} => patient_id) = params) do
    query
    |> where([q], q.patient_id == ^patient_id) 
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> where([q], q.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(query, _params), do: query
end
