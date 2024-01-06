defmodule MedcerterWeb.VisitLive.FormComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Visits

  def update(assigns, socket) do
    changeset = Visits.change_visit(assigns.visit)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  def handle_event("validate", %{"visit" => visit_params}, socket) do
    changeset = 
      socket.assigns.visit
      |> Visits.change_visit(visit_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  def handle_event("save", %{"visit" => visit_params}, socket) do
    save_visit(socket, socket.assigns.action, visit_params)
  end

  defp save_visit(socket, :new, visit_params) do
    case Visits.create_visit(visit_params) do
      {:ok, visit} ->
        {:noreply,
          socket
          |> put_flash(:info, "Visit created successfully")
          |> push_redirect(to: Routes.patient_show_path(
            socket,
            :show,
            visit.patient_id
          ))
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  defp save_visit(socket, :edit, visit_params) do
    case Visits.update_visit(socket.assigns.visit, visit_params) do
      {:ok, visit} ->
        {:noreply,
          socket
          |> put_flash(:info, "Visit created successfully")
          |> push_redirect(to: Routes.patient_show_path(
            socket,
            :show,
            visit.patient_id
          ))
        }

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
