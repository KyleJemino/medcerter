defmodule Medcerter.Repo.Migrations.AddClinicIdToPatients do
  use Ecto.Migration

  def change do
    alter table(:patients) do
      add :clinic_id, references(:clinics, type: :binary_id, on_delete: :nothing)
    end

    create index(:patients, [:clinic_id])
  end
end
