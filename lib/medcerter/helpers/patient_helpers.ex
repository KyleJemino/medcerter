defmodule Medcerter.Helpers.PatientHelpers do
  alias Medcerter.Patients.Patient

  def get_full_name(patient), do: "#{patient.last_name}, #{patient.first_name}, #{patient.middle_name}"
end
