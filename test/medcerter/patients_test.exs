defmodule Medcerter.PatientsTest do
  use Medcerter.DataCase

  alias Medcerter.Patients

  describe "patients" do
    alias Medcerter.Patients.Patient

    import Medcerter.PatientsFixtures
    import Medcerter.AccountsFixtures

    @invalid_attrs %{archived_at: nil, birth_date: nil, first_name: nil, last_name: nil, middle_name: nil, sex: nil}

    test "list_patients/0 returns all patients" do
      patient = patient_fixture()
      assert Patients.list_patients() == [patient]
    end

    test "get_patient!/1 returns the patient with given id" do
      patient = patient_fixture()
      assert Patients.get_patient!(patient.id) == patient
    end

    test "create_patient/1 with valid data creates a patient" do
      %{id: doctor_id} = doctor_fixture()
      valid_attrs = %{doctor_id: doctor_id, birth_date: ~D[2023-02-24], first_name: "some first_name", last_name: "some last_name", middle_name: "some middle_name", sex: :m}

      assert {:ok, %Patient{} = patient} = Patients.create_patient(valid_attrs)
      assert patient.birth_date == ~D[2023-02-24]
      assert patient.first_name == "some first_name"
      assert patient.last_name == "some last_name"
      assert patient.middle_name == "some middle_name"
      assert patient.sex == :m
    end

    test "create_patient/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_patient(@invalid_attrs)
    end

    test "create_patient/1 with archived_at returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Patients.create_patient(@invalid_attrs)
    end

    test "update_patient/2 with valid data updates the patient" do
      patient = patient_fixture()
      update_attrs = %{archived_at: ~U[2023-02-25 13:57:00Z], birth_date: ~D[2023-02-25], first_name: "some updated first_name", last_name: "some updated last_name", middle_name: "some updated middle_name", sex: :f}

      assert {:ok, %Patient{} = patient} = Patients.update_patient(patient, update_attrs)
      assert patient.archived_at == ~U[2023-02-25 13:57:00Z]
      assert patient.birth_date == ~D[2023-02-25]
      assert patient.first_name == "some updated first_name"
      assert patient.last_name == "some updated last_name"
      assert patient.middle_name == "some updated middle_name"
      assert patient.sex == :f
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
