defmodule MedcerterWeb.VisitLive.FormComponent do
  use MedcerterWeb, :live_component
  alias Ecto.Changeset

  alias Medcerter.Visits
  alias Medcerter.Visits.Prescription

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

  def handle_event("add-prescription", _, socket) do
    current_changeset = socket.assigns.changeset
    current_embeds = Changeset.get_change(current_changeset, :prescriptions)
    IO.inspect current_embeds

    updated_changeset = 
      Changeset.put_embed(
        current_changeset,
        :prescriptions,
        current_embeds || [] ++ [
          %Prescription{
            medicine: "",
            times_per_day: 0,
            duration: 0,
            additional_remarks: "",
            recommended_quantity: 0
          }
        ]
      )

    IO.inspect updated_changeset

    {:noreply, assign(socket, :changeset, updated_changeset)}
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
