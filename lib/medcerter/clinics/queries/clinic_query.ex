defmodule Medcerter.Clinics.Queries.ClinicQuery do
  import Ecto.Query
  alias Medcerter.Clinics.Clinic

  def query_clinic(params) do
    query_by(Clinic, params)
  end

  use Medcerter, :basic_queries

  defp query_by(query, _params), do: query
end
