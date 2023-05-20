defmodule Medcerter.Clinics do
  alias Medcerter.Clinics.Resolvers.ClinicResolver, as: CR
  alias Medcerter.Clinics.Resolvers.DoctorClinicResolver, as: DCR

  defdelegate get_clinic(id, params \\ %{}), to: CR
  defdelegate list_clinics(params \\ %{}), to: CR
  defdelegate create_clinic(params), to: CR
  defdelegate create_change_clinic(clinic, params \\ %{}), to: CR

  defdelegate get_doctor_clinic(params), to: DCR
  defdelegate get_doctor_clinic(id, params \\ %{}), to: DCR
  defdelegate create_doctor_clinic(params), to: DCR
  defdelegate change_create_doctor_clinic(doctor_clinic, attrs \\ %{}), to: DCR
end
