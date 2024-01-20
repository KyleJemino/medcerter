defmodule Medcerter.Helpers.PatientHelpers do
  alias Medcerter.Patients.Patient

  def get_full_name(%Patient{} = patient) do
    "#{patient.last_name}, #{patient.first_name}#{if not is_nil(patient.middle_name), do: ", #{patient.middle_name}"}"
  end

  def get_age(%Patient{birth_date: birth_date}) do
    today = Date.utc_today()
    today.year - birth_date.year
  end
end
