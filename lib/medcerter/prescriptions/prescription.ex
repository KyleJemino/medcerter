defmodule Medcerter.Prescriptions.Prescription do
  use Ecto.Schema
  alias Medcerter.Visits.Visit
  alias Medcerter.Prescriptions.Medicine

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "prescriptions" do
    embeds_many :medicines, Medicine
    belongs_to :visit, Visit

    timestamps()
  end
end
