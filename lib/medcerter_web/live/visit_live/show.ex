defmodule MedcerterWeb.VisitLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits

  alias MedcerterWeb.Components.{
    VisitComponents,
    PrescriptionComponents
  }

  alias Medcerter.Prescriptions.Prescription

  def mount(%{"visit_id" => visit_id}, _session, socket) do
    {:ok, socket}
  end

  def handle_params(%{"visit_id" => visit_id}, _url, socket) do
    visit =
      Visits.get_visit_by_params(%{
        "id" => visit_id,
        "preload" => [:prescriptions]
      })

    {:noreply,
     socket
     |> assign(:visit, visit)
     |> assign_title(socket.assigns.live_action)
     |> assign_prescription(socket.assigns.live_action)}
  end

  defp assign_title(socket, :show) do
    socket
    |> assign(:page_title, "New Visit")
  end

  defp assign_title(socket, :edit) do
    socket
    |> assign(:page_title, "Edit Visit")
  end

  defp assign_title(socket, :new_prescription) do
    socket
    |> assign(:page_title, "New Prescription")
  end

  defp assign_prescription(socket, :new_prescription) do
    socket
    |> assign(:prescription, %Prescription{
      visit_id: socket.assigns.visit.id,
      doctor_id: socket.assigns.current_doctor.id,
      patient_id: socket.assigns.patient.id
    })
  end

  defp assign_prescription(socket, _), do: assign(socket, :prescription, nil)
end
