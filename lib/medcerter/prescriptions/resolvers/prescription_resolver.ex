defmodule Medcerter.Prescriptions.Resolvers.PrescriptionResolver do
  alias Medcerter.Repo
  alias Medcerter.Prescriptions.Prescription
  alias Medcerter.Prescriptions.Queries.PrescriptionQuery, as: PQ

  def get_prescription(id) do
    PQ.query_prescription(%{"id" => id})
    |> Repo.one!()
  end

  def create_prescription(attrs \\ %{}) do
    %Prescription{}
    |> change_prescription(attrs)
    |> Repo.insert()
  end

  def update_prescription(%Prescription{} = prescription, attrs) do
    prescription
    |> prescription_update_change(attrs)
    |> Repo.update()
  end

  def change_prescription(%Prescription{} = prescription, attrs) do
    Prescription.changeset(prescription, attrs)
  end

  def prescription_update_change(%Prescription{} = prescription, attrs) do
    Prescription.update_changeset(prescription, attrs)
  end
end
