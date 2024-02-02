defmodule MedcerterWeb.VisitLive.Print do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits

  @impl true
  def mount(%{ "visit_id" => visit_id }, _session, socket) do
    visit = Visits.get_visit_by_params(%{
      "id" => visit_id,
      "preload" => [:prescriptions, :doctor, :patient]
    })

    {:ok, assign(socket, :visit, visit)}
  end
end
