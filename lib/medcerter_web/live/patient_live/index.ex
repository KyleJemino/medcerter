defmodule MedcerterWeb.PatientLive.Index do
  use MedcerterWeb, :live_view

  alias Medcerter.Patients
  alias Medcerter.Patients.Patient
  alias Medcerter.Accounts

  @impl true
  def mount(_params, %{"user_token" => user_token} = _session, socket) do
    {:ok, 
      socket
      |> assign_user(user_token)
      |> assign(:patient_collection, list_patient())
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
    |> assign(:page_title, "Listing Patient")
    |> assign(:patient, nil)
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    patient = Patients.get_patient!(id)
    {:ok, _} = Patients.delete_patient(patient)

    {:noreply, assign(socket, :patient_collection, list_patient())}
  end

  defp assign_user(socket, token) do
    assign_new(socket, :current_user, fn -> 
      Accounts.get_user_by_session_token(token)
    end)
  end

  defp list_patient do
    Patients.list_patient()
  end
end
