defmodule Medcerter.Settings.DoctorSetting do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Accounts.Doctor
  alias Medcerter.Settings.AddressContact

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id

  schema "doctor_settings" do
    field :prescription_header, :string
    field :license_no, :string
    field :ptr_no, :string
    field :s2_no, :string
    embeds_many :addresses_and_contacts, AddressContact
    belongs_to :doctor, Doctor

    timestamps()
  end

  def changeset(%__MODULE__{} = doctor_setting, attrs) do
    doctor_setting
    |> cast(attrs, [
      :prescription_header,
      :license_no,
      :ptr_no,
      :s2_no,
      :doctor_id
    ])
    |> validate_required([:prescription_header, :license_no, :doctor_id])
    |> cast_embed(:addresses_and_contacts, required: true)
    |> validate_length(:addresses_and_contacts, min: 1)
  end
end
