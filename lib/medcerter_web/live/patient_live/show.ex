defmodule MedcerterWeb.PatientLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Patients

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(_params, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))}
  end

  defp page_title(:show), do: "Show Patient"
  defp page_title(:edit), do: "Edit Patient"
end
