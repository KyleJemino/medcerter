defmodule MedcerterWeb.PatientLive.Index do
  use MedcerterWeb, :live_view

  alias Medcerter.Patients
  alias Medcerter.Patients.Patient

  @impl true
  def mount(_params, _session, socket) do
    {:ok, assign_patients(socket)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Patient")
    |> assign(:patient, Patients.get_patient(id))
  end

  defp apply_action(
         socket,
         :new,
         _params
       ) do
    socket
    |> assign(:page_title, "New Patient")
    |> assign(:patient, %Patient{doctor_id: socket.assigns.current_doctor.id})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Patients List")
    |> assign(:patient, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    patient = Patients.get_patient!(id)
    {:ok, _} = Patients.delete_patient(patient)

    {:noreply, assign_patients(socket)}
  end

  defp assign_patients(%{assigns: %{current_doctor: doctor}} = socket) do
    assign(socket, :patients, Patients.list_patients(%{"doctor_id" => doctor.id}))
  end
end
