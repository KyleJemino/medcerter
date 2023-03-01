defmodule Medcerter.PatientsQueriesTest do
  use Medcerter.DataCase
  alias Medcerter.Patients

  import Medcerter.{
    PatientsFixtures,
    AccountsFixtures
  }

  describe "patient_queries" do
    setup do
      doctor_1 = doctor_fixture()
      patient_1 = patient_fixture(%{doctor_id: doctor_1.id})
      doctor_2 = doctor_fixture()
      patient_2 = patient_fixture(%{doctor_id: doctor_2.id})

      %{d1: doctor_1, p1: patient_1, d2: doctor_2, p2: patient_2}
    end

    test "querying for doctor_id returns correct data", %{d1: d1} do
      patients = Patients.list_patients(%{"doctor_id" => d1.id})

      assert Enum.all?(patients, &(&1.doctor_id === d1.id))
    end

    test "querying for id returns correct data", %{p1: p1} do
      assert [result | []] = Patients.list_patients(%{"id" => p1.id})
      assert result.id === p1.id
    end

    test "querying with preload return correct data" do
      patients =
        Patients.list_patients(%{
          "preload" => [:doctor]
        })

      assert Enum.all?(patients, &Ecto.assoc_loaded?(&1.doctor))
    end
  end
end
