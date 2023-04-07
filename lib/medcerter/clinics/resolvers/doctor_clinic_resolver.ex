defmodule Medcerter.Clinics.Resolvers.DoctorClinicResolver do
  import Medcerter.Clinics.Queries.DoctorClinicQuery

  alias Medcerter.Repo
  alias Medcerter.Clinics.DoctorClinic

  def get_doctor_clinic(id, params \\ %{}) do
    params
    |> Map.put("id", id)
    |> query_doctor_clinic()
    |> Repo.one
  end

  def create_doctor_clinic(params) do
    %DoctorClinic{}
    |> DoctorClinic.create_changeset(params)
    |> Repo.insert()
  end

  def change_create_doctor_clinic(%DoctorClinic{} = doctor_clinic, attrs \\ %{}) do
    DoctorClinic.create_changeset(doctor_clinic, attrs)
  end
end
