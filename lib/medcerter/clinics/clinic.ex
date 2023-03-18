defmodule Medcerter.Clinics.Clinic do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "clinics" do
    field :name, :string
    field :address, :string
    field :archived_at, :utc_datetime

    timestamps()
  end

end
