defmodule Medcerter.Repo.Migrations.ReworkVisitsTable do
  use Ecto.Migration

  def change do
    rename table(:visits), :history, to: :interview_notes

    alter table(:visits) do
      add :clinic_id, references(:clinics, type: :binary_id, on_delete: :nothing)
      add :additional_remarks, :text
      add :diagnosis, :string
    end

    create index(:visits, [:clinic_id])
  end
end
