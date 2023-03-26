defmodule Medcerter.Clinics do
  alias Medcerter.Clinics.Resolvers.ClinicResolver, as: CR

  defdelegate get_clinic(id, params), to: CR
end
