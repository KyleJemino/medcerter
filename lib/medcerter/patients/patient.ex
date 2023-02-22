defmodule Medcerter.Patients.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patient" do
    field :address, :string
    field :birthday, :date
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :sex, :string

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :middle_name, :last_name, :birthday, :address, :sex])
    |> validate_required([:first_name, :middle_name, :last_name, :birthday, :address, :sex])
  end
end
