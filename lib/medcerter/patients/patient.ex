defmodule Medcerter.Patients.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Accounts.Doctor

  @required_attr [:first_name, :last_name, :birth_date, :sex, :doctor_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :archived_at, :utc_datetime
    field :birth_date, :date
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :family_history, :string
    field :allergies, {:array, :string}
    field :sex, Ecto.Enum, values: [:m, :f]
    belongs_to :doctor, Doctor

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :last_name, :middle_name, :birth_date, :sex, :archived_at, :family_history, :allergies, :doctor_id])
    |> validate_required(@required_attr)
  end

  def create_changeset(patient, attrs) do
    patient
    |> cast(attrs, [:first_name, :last_name, :middle_name, :birth_date, :sex, :family_history, :allergies, :doctor_id])
    |> validate_required(@required_attr)
  end
end
