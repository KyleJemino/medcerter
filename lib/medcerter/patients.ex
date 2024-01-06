defmodule Medcerter.Patients do
  @moduledoc """
  The Patients context.
  """

  alias Medcerter.Patients.Patient
  alias Medcerter.Patients.Resolvers.PatientResolver, as: PR
  alias Medcerter.Patients.Resolvers.DoctorPatientResolver, as: DPR

  def get_patient(params), do: PR.get_patient(params)
  def get_patient(id, params), do: PR.get_patient(id, params)
  defdelegate list_patients(params \\ %{}), to: PR
  defdelegate create_patient(params \\ %{}), to: PR
  defdelegate update_patient(patient, params \\ %{}), to: PR
  defdelegate change_create_patient(patient, attrs \\ %{}), to: PR

  defdelegate get_doctor_patient(params), to: DPR
  defdelegate list_doctor_patients(params), to: DPR
end
