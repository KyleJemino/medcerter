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
    embeds_many :medicines, Medicine
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
end
