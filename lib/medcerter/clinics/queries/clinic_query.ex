defmodule Medcerter.Clinics.Queries.ClinicQuery do
  import Ecto.Query
  alias Medcerter.Clinics.Clinic
  alias Medcerter.Clinics.DoctorClinic

  def query_clinic(params) do
    query_by(Clinic, params)
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> join(:inner, [c], dc in DoctorClinic, on: c.id == dc.clinic_id)
    |> where([c, dc], dc.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  use Medcerter, :basic_queries
end
