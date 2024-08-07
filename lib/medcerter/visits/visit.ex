defmodule Medcerter.Visits.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Accounts.Doctor
  alias Medcerter.Patients.Patient
  alias Medcerter.Prescriptions.Prescription

  @required_attr [:date_of_visit, :doctor_id, :patient_id, :rest_days, :fit_to_work]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "visits" do
    field :date_of_visit, :date
    field :interview_notes, :string
    field :archived_at, :utc_datetime
    field :additional_remarks, :string
    field :diagnosis, :string
    field :fit_to_work, :date
    field :rest_days, :integer, default: 0
    belongs_to :doctor, Doctor
    belongs_to :patient, Patient
    has_many :prescriptions, Prescription

    timestamps()
  end

  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [
      :date_of_visit,
      :interview_notes,
      :archived_at,
      :additional_remarks,
      :diagnosis,
      :rest_days,
      :patient_id,
      :doctor_id,
      :fit_to_work
    ])
    |> validate_required(@required_attr)
    |> foreign_key_constraint(:doctor_id)
    |> foreign_key_constraint(:patient_id)
  end

  def create_changeset(visit, attrs) do
    visit
    |> cast(attrs, [
      :date_of_visit,
      :interview_notes,
      :additional_remarks,
      :diagnosis,
      :rest_days,
      :patient_id,
      :doctor_id,
      :fit_to_work
    ])
    |> validate_required(@required_attr)
    |> foreign_key_constraint(:doctor_id)
    |> foreign_key_constraint(:patient_id)
  end
end
