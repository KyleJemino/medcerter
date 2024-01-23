defmodule Medcerter.Repo.Migrations.AddDoctorSettings do
  use Ecto.Migration

  def change do
    create table(:doctor_settings, primary_key: false) do
      add :id, :binary_id, primary_key: false
      add :prescription_header, :string, null: false
      add :addresses_and_contacts, {:array, :map}, null: false
      add :license_no, :string, null: false
      add :ptr_no, :string
      add :s2_no, :string
      add :doctor_id, references(:doctors, type: :binary_id, on_delete: :nothing), null: false

      timestamps()
    end

    create unique_index(:doctor_settings, [:doctor_id])
  end
end
