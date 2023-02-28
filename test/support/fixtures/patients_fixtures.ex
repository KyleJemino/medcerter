defmodule Medcerter.PatientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Medcerter.Patients` context.
  """

  import Medcerter.AccountsFixtures,
    only: [
      doctor_fixture: 0
    ]

  @doc """
  Generate a patient.
  """
  def patient_fixture(attrs \\ %{}) do
    %{id: doctor_id} = doctor_fixture()

    {:ok, patient} =
      attrs
      |> Enum.into(%{
        birth_date: ~D[2023-02-24],
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name",
        sex: :m,
        doctor_id: doctor_id
      })
      |> Medcerter.Patients.create_patient()

    patient
  end
end
