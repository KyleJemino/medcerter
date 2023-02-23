defmodule Medcerter.PatientsTest do
  use Medcerter.DataCase

  alias Medcerter.Patients

  describe "patient" do
    alias Medcerter.Patients.Patient

    import Medcerter.PatientsFixtures

    @invalid_attrs %{address: nil, birthday: nil, first_name: nil, last_name: nil, middle_name: nil, sex: nil}

    test "list_patient/0 returns all patient" do
      patient = patient_fixture()
      assert Patients.list_patient() == [patient]
    end

    test "get_patient!/1 returns the patient with given id" do
      patient = patient_fixture()
      assert Patients.get_patient!(patient.id) == patient
    end

    test "create_patient/1 with valid data creates a patient" do
      valid_attrs = %{address: "some address", birthday: ~D[2023-02-21], first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", sex: "some sex"}

      assert {:ok, %Patient{} = patient} = Patients.create_patient(valid_attrs)
      assert patient.address == "some address"
      assert patient.birthday == ~D[2023-02-21]
      assert patient.first_name == "some first_name"
      assert patient.last_name == "some last_name"
      assert patient.middle_name == "some middle_name"
      assert patient.sex == "some sex"
    end

    test "create_patient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_patient(@invalid_attrs)
    end

    test "update_patient/2 with valid data updates the patient" do
      patient = patient_fixture()
      update_attrs = %{address: "some updated address", birthday: ~D[2023-02-22], first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", sex: "some updated sex"}

      assert {:ok, %Patient{} = patient} = Patients.update_patient(patient, update_attrs)
      assert patient.address == "some updated address"
      assert patient.birthday == ~D[2023-02-22]
      assert patient.first_name == "some updated first_name"
      assert patient.last_name == "some updated last_name"
      assert patient.middle_name == "some updated middle_name"
      assert patient.sex == "some updated sex"
    end

    test "update_patient/2 with invalid data returns error changeset" do
      patient = patient_fixture()
      assert {:error, %Ecto.Changeset{}} = Patients.update_patient(patient, @invalid_attrs)
      assert patient == Patients.get_patient!(patient.id)
    end

    test "delete_patient/1 deletes the patient" do
      patient = patient_fixture()
      assert {:ok, %Patient{}} = Patients.delete_patient(patient)
      assert_raise Ecto.NoResultsError, fn -> Patients.get_patient!(patient.id) end
    end

    test "change_patient/1 returns a patient changeset" do
      patient = patient_fixture()
      assert %Ecto.Changeset{} = Patients.change_patient(patient)
    end
  end
end
