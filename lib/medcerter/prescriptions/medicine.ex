defmodule Medcerter.Prescriptions.Medicine do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  embedded_schema do
    field :name, :string
    field :brand, :string
    field :dosage, :string
    field :quantity, :integer
    field :duration, :string
  end

  def changeset(%__MODULE__{} = medicine, attrs \\ %{}) do
    medicine
    |> cast(attrs, [:id, :name, :brand, :dosage, :quantity, :duration])
    |> validate_required([:name, :dosage, :quantity, :duration])
  end
end
