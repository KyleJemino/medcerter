defmodule MedcerterWeb.LiveComponents.PatientFormComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Patients
  alias Medcerter.Patients.Patient

  def update(assigns, socket) do
    changeset = Patients.change_create_patient(assigns.patient)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  def handle_event("validate", %{"patient" => params}, socket) do
    changeset =
      %Patient{}
      |> Patients.change_create_patient(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"patient" => params}, socket) do
    case Patients.create_patient(params) do
      {:ok, _patient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Patient record created")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
