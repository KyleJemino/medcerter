defmodule Medcerter.Clinics do
  alias Medcerter.Clinics.Resolvers.ClinicResolver, as: CR

  defdelegate get_clinic(id, params), to: CR
  defdelegate create_clinic(params), to: CR
  defdelegate create_change_clinic(clinic, params \\ %{}), to: CR
end
