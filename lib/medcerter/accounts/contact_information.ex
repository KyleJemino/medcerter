defmodule Medcerter.Accounts.ContactInformation do
  use Ecto.Schema
  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: false}
  @foreign_key_type :binary_id
  embedded_schema do
    field :address, :string
    field :contact_nos, :string
    field :extra_info, :string
  end

  def changeset(%__MODULE__{} = address_contact, attrs \\ %{}) do
    address_contact
    |> cast(attrs, [:id, :address, :contact_nos, :extra_info])
    |> validate_required([:id, :address, :contact_nos])
  end
end
