defmodule Medcerter.VisitsFixtures do
  alias Medcerter.PatientFixtures, as: PF

  def valid_visits_attributes(attrs \\ %{}) do
    patient = PF.patient_fixture(%{doctor_id: doctor.id})

    Enum.into(attrs, %{
      date: Date.utc_today(),
      history: "lorem ipsum",
      archived_at: nil,
      patient_id: patient.id,
      doctor_id: patient.doctor_id
    })
  end
end
