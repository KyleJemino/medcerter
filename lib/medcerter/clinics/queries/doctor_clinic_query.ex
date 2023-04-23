defmodule Medcerter.Clinics.Queries.DoctorClinicQuery do
  import Ecto.Query
  alias Medcerter.Clinics.DoctorClinic

  def query_doctor_clinic(params) do
    query_by(DoctorClinic, params)
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> where([q], q.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(query, %{"clinic_id" => clinic_id} = params) do
    query
    |> where([q], q.clinic_id == ^clinic_id)
    |> query_by(Map.delete(params, "clinic_id"))
  end

  use Medcerter, :basic_queries
end
