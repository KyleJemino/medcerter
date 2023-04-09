defmodule Medcerter.Repo.Migrations.AddClinicIdToPatients do
  use Ecto.Migration

  def change do
    alter table(:patients) do
      add :clinic_id, references(:patients)
    end

    create index(:patients, [:clinic_id])
  end
end
