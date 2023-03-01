defmodule Medcerter.Patients.Resolvers.PatientResolver do
  import Medcerter.Patients.Queries.PatientQuery
  alias Medcerter.Repo

  def get_patient(id) do
    %{"id" => id}
    |> query_patient()
    |> Repo.one()
  end
end
