defmodule Medcerter.Prescriptions.Queries.PrescriptionQuery do
  import Ecto.Query

  alias Medcerter.Prescriptions.Prescription

  def query_prescription(params) do
    Prescription
    |> query_by(params)
    |> where([q], is_nil(q.archived_at))
  end

  use Medcerter, :basic_queries
end
