defmodule Medcerter.VisitsTest do
  use Medcerter.DataCase

  describe "visits" do
    alias Medcerter.Visits
    alias Medcerter.Visits.Visit
    import Medcerter.VisitsFixtures 
    import Medcerter.PatientsFixtures

    test "list_visits/0 returns all visits" do
      visit = visit_fixture()  
      visit_2 = visit_fixture()

      visits = Visits.list_visits()

      assert Enum.member?(visits, visit)
      assert Enum.member?(visits, visit_2)
    end

    test "get_visit/1 return correct visit" do
      %{id: id} = visit_fixture()

      visit = Visits.get_visit(id)

      assert visit.id === id
    end

    test "get_visit/1 returns nil if visit doesn't exist" do
      assert is_nil(Visits.get_visit(Ecto.UUID.generate()))
    end

    test "create_visit/1 creates visit with valid attributes" do
      %{id: patient_id, doctor_id: doctor_id} = patient_fixture()

      valid_attrs = valid_visit_attrs(%{
        patient_id: patient_id,
        doctor_id: doctor_id,
        history: "cancer"
      })

      assert {:ok, %Visit{} = visit} = Visits.create_visit(valid_attrs)
      assert visit.patient_id === patient_id
      assert visit.doctor_id === doctor_id
      assert visit.history === "cancer"
    end

    test "create_visit/1 returns error changeset with invalid data" do
      assert {:error, %Ecto.Changeset{} = changeset} =
        Visits.create_visit(%{history: "hi"})

      assert %{
        date: ["can't be blank"],
        doctor_id: ["can't be blank"],
        patient_id: ["can't be blank"]
      } = errors_on(changeset)
    end
  end
end
