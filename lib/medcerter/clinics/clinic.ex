defmodule Medcerter.Clinics.Clinic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Clinics.DoctorClinic

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clinics" do
    field :name, :string
    field :address, :string
    field :archived_at, :utc_datetime
    field :doctor_id, :string, virtual: true
    has_many :doctor_clinics, Medcerter.Clinics.DoctorClinic
    has_many :doctors, Medcerter.Accounts.Doctor, through: [:doctor_clinics, :doctor]

    timestamps()
  end

  def changeset(clinic, attrs) do
    clinic
    |> cast(attrs, [
      :name,
      :address,
      :doctor_id,
      :archived_at,
    ])
  end

  def create_changeset(clinic, attrs) do
    clinic
    |> cast(attrs, [:name, :address, :doctor_id])
    |> validate_required([:name, :doctor_id])
    |> put_doctor(changeset)
  end

  # default is owner since this will only be used when creating clinics
  def put_owner(changeset) do
    doctor_id = get_change(changeset, :doctor_id)

    changeset
    |> put_assoc(:doctor_clinics, [%DoctorClinic%{doctor_id: doctor_id, role: :owner}])
    |> delete_change(:doctor_id)
  end
end
