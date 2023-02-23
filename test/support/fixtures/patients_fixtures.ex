defmodule Medcerter.PatientsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Medcerter.Patients` context.
  """

  @doc """
  Generate a patient.
  """
  def patient_fixture(attrs \\ %{}) do
    {:ok, patient} =
      attrs
      |> Enum.into(%{
        address: "some address",
        birthday: ~D[2023-02-21],
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name",
        sex: "some sex"
      })
      |> Medcerter.Patients.create_patient()

    patient
  end
end
