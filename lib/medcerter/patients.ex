defmodule Medcerter.Patients do
  @moduledoc """
  The Patients context.
  """

  alias Medcerter.Patients.Patient
  alias Medcerter.Patients.Resolvers.PatientResolver, as: PR

  defdelegate get_patient(id), to: PR
  defdelegate list_patients(params \\ %{}), to: PR
  defdelegate create_patient(params \\ %{}), to: PR
  defdelegate update_patient(patient, params \\ %{}), to: PR
  defdelegate change_create_patient(patient, attrs \\ %{}), to: PR
end
