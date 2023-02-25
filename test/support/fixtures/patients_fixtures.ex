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
        archived_at: ~U[2023-02-24 13:57:00Z],
        birth_date: ~D[2023-02-24],
        first_name: "some first_name",
        last_name: "some last_name",
        middle_name: "some middle_name",
        sex: :m
      })
      |> Medcerter.Patients.create_patient()

    patient
  end
end
