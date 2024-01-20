defmodule Medcerter.Repo.Migrations.AddAddressToPatient do
  use Ecto.Migration

  def change do
    alter table(:patients) do
      add :address, :string, null: false, default: "N/A"
    end
  end
end
