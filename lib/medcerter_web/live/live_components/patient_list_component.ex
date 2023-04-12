defmodule MedcerterWeb.LiveComponents.PatientListComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Patients
  alias Medcerter.Patients.Patient

  def update(%{params: params}, socket) do
    {:ok, 
      assign_new(socket, :patients, fn -> Patients.list_patients(params) end)
    }
  end

  def handle_event("refresh", _params, socket) do
    {:noreply, socket}
  end
end
