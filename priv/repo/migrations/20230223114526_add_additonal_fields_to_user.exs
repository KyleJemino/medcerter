defmodule Medcerter.Repo.Migrations.AddAdditonalFieldsToUser do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :first_name, :string, null: false, default: "First"
      add :last_name, :string, null: false, default: "Last"
      add :middle_name, :string
      add :sex, :string
    end
  end
end
