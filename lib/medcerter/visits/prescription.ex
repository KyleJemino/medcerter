defmodule Medcerter.Visits.Prescription do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :medicine, :string
    field :times_per_day, :integer
    field :duration, :integer
    field :additional_remarks, :string
    field :recommended_quantity, :integer
  end

  def changeset(%__MODULE__{} = prescription, attrs \\ %{}) do
    prescription
    |> cast(attrs, [:medicine, :times_per_day, :duration, :additional_remarks, :recommended_quantity])
    |> validate_required([:medicine, :times_per_day])
  end
end
