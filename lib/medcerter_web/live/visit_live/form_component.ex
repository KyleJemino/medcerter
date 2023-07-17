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

  def handle_event(_, %{"visit" => visit_params}, socket) do
    changeset = 
      socket.assigns.visit
      |> Visits.change_visit(visit_params)
      |> Map.put(:action, :validate)

    IO.inspect visit_params

    {:noreply, assign(socket, :changeset, changeset)}
  end
end
