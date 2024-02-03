defmodule MedcerterWeb.PrescriptionLive.Print do
  use MedcerterWeb, :live_view

  alias Medcerter.Prescriptions
  alias MedcerterWeb.Components.PrescriptionComponents, as: PC

  @impl true
  def mount(%{"prescription_id" => prescription_id}, _session, socket) do
    prescription = Prescriptions.get_prescription_by_params(%{
      "id" => prescription_id,
      "preload" => [:doctor, :patient]
    })

    {:ok, 
      assign(socket, prescription: prescription), 
      layout: {MedcerterWeb.LayoutView, "print.html"}}
  end
end
