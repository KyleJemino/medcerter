defmodule Medcerter.Repo.Migrations.AddPrescriptions do
  use Ecto.Migration

  def change do
    create table(:prescriptions, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :medicine, {:array, :map}
      add :visit_id, references(:visits, type: :binary_id, on_delete: :nothing), null: false
    end

    create index(:prescriptions, [:visit_id])
  end
end
