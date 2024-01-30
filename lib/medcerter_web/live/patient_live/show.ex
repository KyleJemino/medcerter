defmodule MedcerterWeb.PatientLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits
  alias Medcerter.Visits.Visit
  alias Medcerter.Prescriptions
  alias MedcerterWeb.Components.PatientComponents

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(
         %{
           assigns: %{
             current_doctor: doctor,
             patient: patient
           }
         } = socket,
         action,
         _params
       )
       when action in [:show, :edit, :new_visit] do
     visits = 
       Visits.list_visits(%{
         "patient_id" => patient.id,
         "preload" => [
           prescriptions: Prescriptions.query_prescription()
         ]
       })

    socket
    |> assign(:page_title, "#{if action === :edit, do: "Edit "}Patient Information")
    |> assign(:visit, %Visit{
      doctor_id: doctor.id,
      patient_id: patient.id
    })
    |> assign(:visits, visits)
  end
end
