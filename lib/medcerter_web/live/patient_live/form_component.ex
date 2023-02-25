defmodule MedcerterWeb.PatientLive.FormComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Patients

  @impl true
  def update(%{patient: patient} = assigns, socket) do
    changeset = Patients.change_patient(patient)

    {:ok,
     socket
     |> assign(assigns)
     |> assign(:changeset, changeset)}
  end

  @impl true
  def handle_event("validate", %{"patient" => patient_params}, socket) do
    changeset =
      socket.assigns.patient
      |> Patients.change_patient(patient_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"patient" => patient_params}, socket) do
    save_patient(socket, socket.assigns.action, patient_params)
  end

  defp save_patient(socket, :edit, patient_params) do
    case Patients.update_patient(socket.assigns.patient, patient_params) do
      {:ok, _patient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Patient updated successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_patient(socket, :new, patient_params) do
    IO.inspect patient_params
    case Patients.create_patient(patient_params) do
      {:ok, _patient} ->
        {:noreply,
         socket
         |> put_flash(:info, "Patient created successfully")
         |> push_redirect(to: socket.assigns.return_to)}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, changeset: changeset)}
    end
  end
end
