defmodule Medcerter.Prescriptions.Prescription do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Visits.Visit
  alias Medcerter.Prescriptions.Medicine
  alias Medcerter.Patients.Patient
  alias Medcerter.Accounts.Doctor

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prescriptions" do
    field :archived_at, :utc_datetime
    embeds_many :medicines, Medicine, on_replace: :delete
    belongs_to :visit, Visit
    belongs_to :patient, Patient
    belongs_to :doctor, Doctor

    timestamps()
  end

  def changeset(%__MODULE__{} = prescription, attrs) do
    prescription
    |> cast(attrs, [
      :visit_id,
      :patient_id,
      :doctor_id
    ])
    |> validate_required([:patient_id, :doctor_id])
    |> foreign_key_constraint(:visit_id)
    |> foreign_key_constraint(:patient_id)
    |> foreign_key_constraint(:doctor_id)
    |> cast_embed(:medicines, required: true)
  end

  def update_changeset(%__MODULE__{} = prescription, attrs) do
    prescription
    |> cast(attrs, [])
    |> cast_embed(:medicines, required: true)
  end

  def archive_changeset(%__MODULE__{} = prescription) do
    now = DateTime.utc_now(:second)

    change(prescription, archived_at: now)
  end
end
