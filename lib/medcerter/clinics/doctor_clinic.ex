defmodule Medcerter.Clinics.DoctorClinics do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Clinics.Clinic
  alias Medcerter.Accounts.Doctor

  @required_attrs [:role, :clinic_id, :doctor_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "doctor_clinics" do
    field :role, Ecto.Enum, values: [:owner, :normal]
    field :archived_at, :utc_datetime
    belongs_to :clinic, Clinic
    belongs_to :doctor, Doctor

    timestamps()
  end

  def changeset(doctor_clinic, attrs) do
    doctor_clinic
    |> cast(attrs, [
      :role,
      :clinic_id,
      :doctor_id
    ])
  end
end
