defmodule Medcerter.Repo.Migrations.CreateDoctorsAuthTables do
  use Ecto.Migration

  def change do
    execute "CREATE EXTENSION IF NOT EXISTS citext", ""

    create table(:doctors, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :email, :citext, null: false
      add :first_name, :string, null: false
      add :middle_name, :string
      add :last_name, :string, null: false
      add :sex, :string
      add :hashed_password, :string, null: false
      add :confirmed_at, :naive_datetime
      timestamps()
    end

    create unique_index(:doctors, [:email])

    create table(:doctors_tokens, primary_key: false) do
      add :id, :binary_id, primary_key: true
      add :doctor_id, references(:doctors, type: :binary_id, on_delete: :delete_all), null: false
      add :token, :binary, null: false
      add :context, :string, null: false
      add :sent_to, :string
      timestamps(updated_at: false)
    end

    create index(:doctors_tokens, [:doctor_id])
    create unique_index(:doctors_tokens, [:context, :token])
  end
end
