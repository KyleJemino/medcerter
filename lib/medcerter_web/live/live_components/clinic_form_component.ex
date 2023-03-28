defmodule MedcerterWeb.LiveComponents.ClinicFormComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Clinics

  @impl true
  def update(%{clinic: clinic} = assigns, socket) do
    changeset = Clinics.create_change_clinic(clinic)

    {:ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  def handle_event("validate", %{"clinic" => clinic_params}, socket) do
    changeset =
      socket.assigns.clinic
      |> Clinics.create_change_clinic(clinic_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"clinic" => clinic_params}, socket) do
    case Clinics.create_clinic(clinic_params) do
      {:ok, _patient} ->
        {:noreply,
          socket
          |> put_flash(:info, "Clinic created successfully")
          |> push_redirect(to: socket.assigns.return_to)
        }
    end
  end
end
