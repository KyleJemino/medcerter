defmodule Medcerter.Visits do
  @moduledoc """
  Visits Context
  """

  import Medcerter.Visits.Resolvers.VisitResolver, as: VR

  defdelegate list_visits(params), to: VR
  defdelegate get_visit(id), to: VR
  defdelegate create_visit(attrs), to: VR
end
