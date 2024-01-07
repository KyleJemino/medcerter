defmodule Medcerter.Helpers.PatientHelpers do
  alias Medcerter.Patients.Patient

  def get_full_name(%Patient{} = patient) do 
    "#{patient.last_name}, #{patient.first_name}#{if not is_nil(patient.middle_name), do: ", #{patient.middle_name}"}"
  end
end
