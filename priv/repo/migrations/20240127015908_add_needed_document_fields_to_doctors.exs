defmodule Medcerter.Repo.Migrations.AddNeededDocumentFieldsToDoctors do
  use Ecto.Migration

  def change do
    alter table(:doctor_settings) do
      add :header, :string, null: false
      add :contact_information, {:array, :map}, null: false
      add :license_no, :string, null: false
      add :ptr_no, :string
      add :s2_no, :string
    end
  end
end
