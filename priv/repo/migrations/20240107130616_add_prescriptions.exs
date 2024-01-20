defmodule Medcerter.Repo.Migrations.AddPrescriptions do
  use Ecto.Migration

  def change do
    create table(:prescriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :medicines, {:array, :map}
      add :visit_id, references(:visits, type: :binary_id, on_delete: :nothing), null: false
      add :doctor_id, references(:doctors, type: :binary_id, on_delete: :nothing), null: false
      add :patient_id, references(:patients, type: :binary_id, on_delete: :nothing), null: false

      timestamps()
    end

    create index(:prescriptions, [:visit_id])
    create index(:prescriptions, [:doctor_id])
    create index(:prescriptions, [:patient_id])
  end
end
