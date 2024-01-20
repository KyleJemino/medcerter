defmodule Medcerter.Repo.Migrations.RemoveClinics do
  use Ecto.Migration

  def change do
    drop_if_exists index(:patients, [:clinic_id])

    alter table(:patients) do
      remove :clinic_id, references(:clinics, type: :binary_id, on_delete: :nothing)
    end

    drop_if_exists index(:doctor_clinics, [:clinic_id])
    drop_if_exists index(:doctor_clinics, [:doctor_id])

    drop_if_exists table(:doctor_clinics)

    drop_if_exists index(:visits, [:clinic_id])
    
    alter table(:visits) do
      remove :clinic_id, references(:clinics, type: :binary_id, on_delete: :nothing)
    end

    drop_if_exists table(:clinics)
  end
end
