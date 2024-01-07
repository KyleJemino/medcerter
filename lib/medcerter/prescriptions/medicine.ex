defmodule Medcerter.Prescriptions.Medicine do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :name, :string
    field :brand, :string
    field :sig, :string
    field :quantity, :integer
  end

  def changeset(%__MODULE__{} = medicine, attrs \\ %{}) do
    medicine
    |> cast(attrs, [:name, :brand, :sig, :quantity])
    |> validate_required([:name, :sig, :quantity])
  end
end
