defmodule Medcerter.Patients.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  @required_attr [:first_name, :last_name, :birth_date, :sex]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :archived_at, :utc_datetime
    field :birth_date, :date
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :sex, Ecto.Enum, values: [:m, :f]
    field :doctor_id, :binary_id

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :last_name, :middle_name, :birth_date, :sex, :archived_at])
    |> validate_required(@required_attr)
  end

  def create_changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :last_name, :middle_name, :birth_date, :sex])
    |> validate_required(@required_attr)
  end
end
