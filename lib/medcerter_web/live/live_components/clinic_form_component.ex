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
end
