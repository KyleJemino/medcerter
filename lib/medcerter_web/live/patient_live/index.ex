defmodule MedcerterWeb.PatientLive.Index do
  use MedcerterWeb, :live_view

  alias Medcerter.Patients
  alias Medcerter.Patients.Patient

  @impl true
  def mount(_params, %{"doctor_token" => token}, socket) do
    {:ok, 
      socket 
      |> assign(:patients, list_patients())
      |> assign_doctor(token)
    }
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Patient")
    |> assign(:patient, Patients.get_patient!(id))
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Patient")
    |> assign(:patient, %Patient{})
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Listing Patients")
    |> assign(:patient, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    patient = Patients.get_patient!(id)
    {:ok, _} = Patients.delete_patient(patient)

    {:noreply, assign(socket, :patients, list_patients())}
  end

  defp list_patients do
    Patients.list_patients()
  end
end
