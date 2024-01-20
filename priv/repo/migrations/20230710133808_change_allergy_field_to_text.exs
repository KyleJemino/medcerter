defmodule Medcerter.Repo.Migrations.ChangeAllergyFieldToText do
  use Ecto.Migration

  def change do
    execute(up(), down())
  end

  defp up() do
    "ALTER TABLE patients ALTER allergies TYPE text USING array_to_string(allergies, ', ')"
  end

  defp down() do
    "ALTER TABLE patients ALTER allergies TYPE varchar(255)[] USING array[learning_style]"
  end
end
