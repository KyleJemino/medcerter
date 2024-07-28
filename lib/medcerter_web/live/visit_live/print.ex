defmodule MedcerterWeb.VisitLive.Print do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits
  alias Medcerter.Prescriptions
  alias MedcerterWeb.Components.VisitComponents, as: VC
  alias MedcerterWeb.Components.PrescriptionComponents, as: PC

  @impl true
  def mount(%{"visit_id" => visit_id}, _session, socket) do
    visit =
      Visits.get_visit_by_params(%{
        "id" => visit_id,
        "preload" => [:doctor, :patient, prescriptions: Prescriptions.query_prescription()]
      })

    {:ok, assign(socket, visit: visit), layout: {MedcerterWeb.LayoutView, "print.html"}}
  end
end
