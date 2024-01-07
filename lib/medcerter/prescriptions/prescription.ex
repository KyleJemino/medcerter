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

  def changeset(%__MODULE__{} = prescription, attrs) do
    prescription 
    |> cast(attrs, [
      :visit_id
    ])
    |> foreign_key_constraint(:visit_id)
    |> cast_embed(:medicines, required: true)
  end
end
