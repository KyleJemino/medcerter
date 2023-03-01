defmodule Medcerter.Patients.Resolvers.PatientResovler do
  def get_patient(id) do
    %{"id" => id}
    |> query_patient()
    |> Repo.one()
  end
end
