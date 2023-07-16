defmodule Medcerter.Repo.Migrations.AddDateFieldsToVisitsTable do
  use Ecto.Migration

  def change do
    rename table(:visits), :date, to: :date_of_visit

    alter table(:visits) do
      modify :date_of_visit, :date, null: false
      add :fit_to_work, :date, null: true
      add :rest_days, :int, null: false, default: 0 
    end
  end
end
