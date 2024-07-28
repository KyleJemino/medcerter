defmodule Medcerter.Repo.Migrations.MakeFitToWorkRequired do
  use Ecto.Migration

  def change do
    execute(
      "UPDATE visits SET fit_to_work = NOW() WHERE fit_to_work IS NULL"
    )

    alter table(:visits) do
      modify :fit_to_work, :date, null: false, default: fragment("now()")
    end
  end
end
