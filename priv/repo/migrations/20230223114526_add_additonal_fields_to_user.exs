defmodule Medcerter.Repo.Migrations.AddAdditonalFieldsToUser do
  use Ecto.Migration

  def change do
    alter table (:users) do
      add :first_name, :string
      add :last_name, :string
      add :middle_name, :string
      add :sex, :string
    end
  end
end
