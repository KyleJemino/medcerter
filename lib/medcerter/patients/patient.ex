defmodule Medcerter.Patients.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Clinics.Clinic

  @required_attr [:first_name, :last_name, :birth_date, :sex, :clinic_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :archived_at, :utc_datetime
    field :birth_date, :date
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :family_history, :string
    field :allergies, {:array, :string}, default: []
    field :sex, Ecto.Enum, values: [:m, :f]
    belongs_to :clinic, Clinic

    timestamps()
  end

  @doc false
  def changeset(patient, attrs) do
    patient
    |> cast(attrs, [
      :first_name,
      :last_name,
      :middle_name,
      :birth_date,
      :sex,
      :archived_at,
      :family_history,
      :clinic_id
    ])
    |> cast_format_allergies(attrs)
    |> validate_required(@required_attr)
    |> foreign_key_constraint(:clinic_id)
  end

  def create_changeset(patient, attrs) do
    patient
    |> cast(attrs, [
      :first_name,
      :last_name,
      :middle_name,
      :birth_date,
      :sex,
      :family_history,
      :clinic_id
    ])
    |> cast_format_allergies(attrs)
    |> validate_required(@required_attr)
    |> foreign_key_constraint(:clinic_id)
  end

  defp cast_format_allergies(changeset, attrs) do
    formatted_allergies =
      changeset 
      |> cast(attrs, [:allergies]) 
      |> get_change(:allergies, [])
      |> Enum.filter(&(&1 != ""))
      |> Enum.uniq()

    put_change(changeset, :allergies, formatted_allergies)
  end
end
