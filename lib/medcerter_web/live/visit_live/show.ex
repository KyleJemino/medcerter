defmodule MedcerterWeb.VisitLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits
  alias MedcerterWeb.Components.VisitComponents
  alias Medcerter.Prescriptions.Prescription

  def mount(%{"visit_id" => visit_id}, _session, socket) do
    {:ok, 
      assign_new(
        socket, 
        :visit, 
        fn -> Visits.get_visit(visit_id) end
      )}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, 
      socket
      |> assign_title(socket.assigns.live_action)
      |> assign_prescription(socket.assigns.live_action)
    }
  end

  defp assign_title(socket,:show) do
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
