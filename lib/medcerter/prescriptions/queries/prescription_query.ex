defmodule Medcerter.Prescriptions.Queries.PrescriptionQuery do
  import Ecto.Query

  alias Medcerter.Prescriptions.Prescription

  def query_prescription(params) do
    query_by(Prescription, params)
  end

  use Medcerter, :basic_queries
end
