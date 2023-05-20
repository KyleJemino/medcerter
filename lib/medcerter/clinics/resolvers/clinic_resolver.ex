defmodule Medcerter.Clinics.Resolvers.ClinicResolver do
  import Medcerter.Clinics.Queries.ClinicQuery

  alias Medcerter.Repo
  alias Medcerter.Clinics.Clinic

  def get_clinic(id, params \\ %{}) do
    params
    |> Map.put("id", id)
    |> query_clinic()
    |> Repo.one()
  end

  def list_clinics(params) do
    params
    |> query_clinic()
    |> Repo.all()
  end

  def create_clinic(params) do
    %Clinic{}
    |> Clinic.create_changeset(params)
    |> Repo.insert()
  end

  def create_change_clinic(%Clinic{} = clinic, attrs \\ %{}) do
    Clinic.create_changeset(clinic, attrs)
  end
end
