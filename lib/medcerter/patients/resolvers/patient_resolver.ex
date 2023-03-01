defmodule Medcerter.Patients.Resolvers.PatientResovler do
  def get_patient(id) do
    params
    |> query_patient(%{"id" => id})
    |> Repo.one()
  end
end
