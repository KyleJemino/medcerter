defmodule Medcerter.Repo.Migrations.AddPrescriptionToVisitTable do
  use Ecto.Migration

  def change do
    alter table(:visits) do
      add :prescriptions, {:array, :map}
    end
  end
end
