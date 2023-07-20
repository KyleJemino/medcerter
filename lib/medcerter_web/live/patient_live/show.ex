defmodule MedcerterWeb.PatientLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Patients
  alias Medcerter.Visits
  alias Medcerter.Visits.Visit

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply,
      apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(
    %{
      assigns: %{
        current_clinic: clinic,
        current_doctor: doctor,
        patient: patient
      }
    } = socket, 
    action, 
    _params
  ) when action in [:show, :edit] do
    socket
    |> assign(:page_title, "#{if action === :edit, do: "Edit "}Patient Information")
    |> assign(:visit, %Visit{
      clinic_id: clinic.id,
      doctor_id: doctor.id,
      patient_id: patient.id
    })
  end

  defp apply_action(
    socket,
    :edit_visit,
    %{"visit_id" => id}
  ) do
    socket
    |> assign(:page_title, "Edit Visit")
    |> assign(:visit, Visits.get_visit(id))
  end

  defp page_title(:show), do: "Show Patient"
  defp page_title(:edit), do: "Edit Patient"
end
