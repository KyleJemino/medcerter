defmodule Medcerter.VisitsFixtures do
  alias Medcerter.PatientsFixtures, as: PF
  alias Medcerter.Visits

  def visit_fixture(attrs \\ %{}) do
    %{id: patient_id, doctor_id: doctor_id} = PF.patient_fixture()

    valid_attrs = Enum.into(attrs, %{
      date: DateTime.utc_now(),
      history: "lorem ipsum",
      patient_id: patient_id,
      doctor_id: doctor_id
    })

    {:ok, visit} = Visits.create_visit(valid_attrs)
    visit
  end
end
