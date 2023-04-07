defmodule MedcerterWeb.LiveComponents.DoctorClinicFormComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Clinics

  @impl true
  def update(assigns, socket) do
    changeset = Clinics.change_create_doctor_clinic(assigns.doctor_clinic)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)}
  end

  def handle_event("validate", %{"doctor_clinic" => params}, socket) do
    changeset =
      socket.assigns.doctor_clinic
      |> Clinics.change_create_doctor_clinic(params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end
end
