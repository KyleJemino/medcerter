defmodule :"Elixir.Medcerter.Repo.Migrations.Add-personal-social-environmental-history-to-patients" do
  use Ecto.Migration

  def change do
    alter table(:patients) do
      add :personal_social_environmental_history, :string
    end
  end
end
