defmodule Medcerter.Settings.AddressContact do
  use Ecto.Schema
  import Ecto.Changeset

  embedded_schema do
    field :address, :string
    field :contact_nos, :string
    field :extra_info, :string
  end

  def changeset(%__MODULE__{} = address_contact, attrs \\ %{}) do
    address_contact
    |> cast(attrs, [:address, :contact_nos, :extra_info])
    |> validate_required([:address, :contact_nos])
  end
end
