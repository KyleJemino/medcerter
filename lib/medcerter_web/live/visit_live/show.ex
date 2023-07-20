defmodule MedcerterWeb.VisitLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits
  alias Medcerter.Visits.Visit
  alias MedcerterWeb.Components.PatientComponents

  def mount(%{"visit_id" => visit_id}, _session, socket) do
    {:ok, 
      assign_new(
        socket, 
        :visit, 
        fn -> Visits.get_visit(visit_id) end
      )}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(
    socket, 
    :show, 
    _params
  ) do
    socket
    |> assign(:page_title, "New Visit")
  end

  defp apply_action(
    socket, 
    :edit, 
    _params
  ) do
    socket
    |> assign(:page_title, "Edit Visit")
  end
end
