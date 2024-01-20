defmodule Medcerter.Prescriptions.Resolvers.PrescriptionResolver do
  alias Medcerter.Repo
  alias Medcerter.Prescriptions.Prescription

  def create_prescription(attrs \\ %{}) do
    %Prescription{}
    |> change_prescription(attrs)
    |> Repo.insert()
  end

  def change_prescription(%Prescription{} = prescription, attrs) do
    Prescription.changeset(prescription, attrs)
  end
end
