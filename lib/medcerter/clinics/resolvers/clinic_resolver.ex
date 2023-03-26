defmodule Medcerter.Clinics.Resolvers.ClinicResolver do
  import Medcerter.Clinics.Queries.ClinicQuery
  alias Medcerter.Repo

  def get_clinic(id, params \\ %{}) do
    params
    |> Map.put("id", id)
    |> query_clinic()
    |> Repo.one()
  end
end
