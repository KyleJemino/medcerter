defmodule Medcerter.Patients.Patient do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Visits.Visit
  alias Medcerter.Patients.DoctorPatient
  alias Medcerter.Prescriptions.Prescription

  @required_attr [:first_name, :last_name, :birth_date, :sex, :address]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "patients" do
    field :archived_at, :utc_datetime
    field :birth_date, :date
    field :first_name, :string
    field :last_name, :string
    field :middle_name, :string
    field :family_history, :string
    field :personal_social_environmental_history, :string
    field :address, :string
    field :allergies, :string
    field :sex, Ecto.Enum, values: [:m, :f]
    field :doctor_id, :string, virtual: true

    has_many :doctor_patients, DoctorPatient
    has_many :doctors, through: [:doctor_patients, :doctor]
    has_many :visits, Visit
    has_many :prescriptions, Prescription

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
      :allergies,
      :address,
      :doctor_id,
      :personal_social_environmental_history
    ])
    |> validate_required(@required_attr)
  end

  def create_changeset(patient, attrs) do
    patient
    |> cast(attrs, [
      :first_name,
      :last_name,
      :middle_name,
      :birth_date,
      :doctor_id,
      :sex,
      :family_history,
      :allergies,
      :address,
      :personal_social_environmental_history
    ])
    |> validate_required([:doctor_id | @required_attr])
  end
end
