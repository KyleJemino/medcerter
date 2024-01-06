defmodule Medcerter.Patients.Resolvers.DoctorPatientResolver do
  alias Medcerter.Repo
  alias Medcerter.Patients.DoctorPatient
  alias Medcerter.Patients.Queries.DoctorPatientQuery, as: DPQ

  def get_doctor_patient(params) do
    params
    |> DPQ.query_doctor_patient()
    |> Repo.one()
  end

  def list_doctor_patients(params) do
    params
    |> DPQ.query_doctor_patient()
    |> Repo.all()
  end
end
