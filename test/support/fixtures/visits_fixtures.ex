defmodule Medcerter.VisitsFixtures do
  alias Medcerter.PatientsFixtures, as: PF
  alias Medcerter.Visits

  def valid_visit_attrs(attrs \\ %{}) do
    %{id: patient_id, doctor_id: doctor_id} = PF.patient_fixture()

    Enum.into(attrs, %{
      date: DateTime.utc_now(),
      history: "lorem ipsum",
      patient_id: patient_id,
      doctor_id: doctor_id
    })
  end

  def visit_fixture(attrs \\ %{}) do
    {:ok, visit} = 
      attrs
      |> valid_visit_attrs()
      |> Visits.create_visit()
    visit
  end
end
