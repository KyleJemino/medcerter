defmodule Medcerter.Repo.Migrations.RemoveDoctorSettings do
  use Ecto.Migration

  def change do
    drop unique_index(:doctor_settings, [:doctor_id])

    drop table(:doctor_settings)
  end
end
