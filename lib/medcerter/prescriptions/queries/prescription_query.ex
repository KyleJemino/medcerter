defmodule Medcerter.Prescriptions.Queries.PrescriptionQuery do
  import Ecto.Query

  alias Medcerter.Prescriptions.Prescription

  def query_prescription(params) do
    Prescription
    |> query_by(params)
    |> where([q], is_nil(q.archived_at))
  end

  defp query_by(query, %{"visit_id" => visit_id} = params) do
    query
    |> where([q], q.visit_id == ^visit_id)
    |> query_by(Map.delete(params, "visit_id"))
  end

  use Medcerter, :basic_queries
end
