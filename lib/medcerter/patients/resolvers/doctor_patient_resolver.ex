defmodule Medcerter.Patients.Resolvers.DoctorPatientResolver do
  alias Medcerter.Repo
  alias Medcerter.Patients.Queries.DoctorPatientQuery, as: DPQ
  import Ecto.Changeset

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

  def changeset(doctor_patient, attrs) do
    doctor_patient
    |> cast(attrs, [:doctor_id, :patient_id])
    |> validate_required([:doctor_id, :patient_id])
  end
end
