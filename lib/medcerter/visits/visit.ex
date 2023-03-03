defmodule Medcerter.Visits.Visit do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Accounts.Doctor
  alias Medcerter.Accounts.Patient

  @required_attr [:date, :doctor_id, :patient_id]

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "visits" do
    field :date, :utc_datetime
    field :history, :string
    field :archived_at, :utc_datetime
    belongs_to :doctor, Doctor
    belongs_to :patient, Patient
  end

  def changeset(visit, attrs) do
    visit
    |> cast(attrs, [
      :date,
      :history,
      :archived_at,
      :patient_id,
      :doctor_id,
    ])
    |> validate_required(@required_attr)
  end

  def create_changeset(visit, attrs) do
    visit
    |> cast(attrs, [
      :date,
      :history,
      :patient_id,
      :doctor_id
    ])
    |> validate_required(@required_attr)
  end
end
