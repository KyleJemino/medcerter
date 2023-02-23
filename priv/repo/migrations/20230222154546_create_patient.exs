defmodule Medcerter.Repo.Migrations.CreatePatient do
  use Ecto.Migration

  def change do
    create table(:patient, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :first_name, :string
      add :middle_name, :string
      add :last_name, :string
      add :birthday, :date
      add :address, :string
      add :sex, :string

      timestamps()
    end
  end
end
