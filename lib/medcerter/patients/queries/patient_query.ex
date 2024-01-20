defmodule Medcerter.Patients.Queries.PatientQuery do
  import Ecto.Query

  alias Medcerter.Patients.{
    Patient,
    DoctorPatient
  }

  def query_patient(params) do
    query_by(Patient, params)
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> join(:inner, [q], dp in DoctorPatient, on: q.id == dp.patient_id)
    |> where([q, dp], dp.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  defp query_by(
         query,
         %{
           "last_name" => last_name
         } = params
       ) do
    last_name_query = "%#{last_name}%"

    query
    |> where([q], ilike(q.last_name, ^last_name_query))
    |> query_by(Map.delete(params, "last_name"))
  end

  defp query_by(
         query,
         %{
           "first_name" => first_name
         } = params
       ) do
    first_name_query = "%#{first_name}%"

    query
    |> where([q], ilike(q.first_name, ^first_name_query))
    |> query_by(Map.delete(params, "first_name"))
  end

  defp query_by(
         query,
         %{
           "middle_name" => middle_name
         } = params
       ) do
    middle_name_query = "%#{middle_name}%"

    query
    |> where([q], ilike(q.middle_name, ^middle_name_query))
    |> query_by(Map.delete(params, "middle_name"))
  end

  use Medcerter, :basic_queries
end
