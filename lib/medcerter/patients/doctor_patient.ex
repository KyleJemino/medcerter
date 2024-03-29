defmodule Medcerter.Patients.DoctorPatient do
  use Ecto.Schema

  alias Medcerter.Accounts.Doctor
  alias Medcerter.Patients.Patient

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "doctor_patients" do
    belongs_to :doctor, Doctor
    belongs_to :patient, Patient

    timestamps()
  end
end
