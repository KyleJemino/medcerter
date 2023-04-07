defmodule Medcerter.Repo.Migrations.AddUniqueDoctorClinicIdx do
  use Ecto.Migration

  def change do
    create unique_index(:doctor_clinics, [:clinic_id, :doctor_id], name: :uniq_doctor_clinic_idx)
  end
end
