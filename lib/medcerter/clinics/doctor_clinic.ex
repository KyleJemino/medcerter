defmodule Medcerter.Clinics.DoctorClinic do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Clinics.Clinic
  alias Medcerter.Accounts.Doctor
  alias Medcerter.Repo

  @required_attrs [:role, :clinic_id, :doctor_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "doctor_clinics" do
    field :role, Ecto.Enum, values: [:owner, :normal]
    field :archived_at, :utc_datetime
    field :doctor_email, :string, virtual: true
    belongs_to :clinic, Clinic
    belongs_to :doctor, Doctor

    timestamps()
  end

  def changeset(doctor_clinic, attrs) do
    doctor_clinic
    |> cast(attrs, [
      :role,
      :clinic_id,
      :doctor_id,
      :archived_at,
      :doctor_email
    ])
    |> foreign_key_constraint(:clinic_id)
    |> foreign_key_constraint(:doctor_id)
  end

  def create_changeset(doctor_clinic, attrs) do
    doctor_clinic
    |> cast(attrs, [
      :role,
      :clinic_id,
      :doctor_email
    ])
    |> validate_required([:clinic_id, :doctor_email, :role])
    |> foreign_key_constraint(:clinic_id)
    |> put_doctor_from_email()
  end

  defp put_doctor_from_email(changeset) do
    doctor_email = get_change(changeset, :doctor_email)

    if is_nil(doctor_email) do
      add_error(changeset, :doctor_email, "is required")
    else
      case Repo.get_by(Doctor, email: doctor_email) do
        %Doctor{id: doctor_id} ->
          changeset
          |> put_change(:doctor_id, doctor_id)
          |> foreign_key_constraint(:doctor_id)
          |> delete_change(:doctor_email)
          |> unique_constraint(
            [:clinic_id, :doctor_id],
            name: :uniq_doctor_clinic_idx,
            error_key: :doctor_email,
            message: "has already joined or been invited"
          )

        _ ->
          add_error(changeset, :doctor_email, "doesn't exist")
      end
    end
  end
end
