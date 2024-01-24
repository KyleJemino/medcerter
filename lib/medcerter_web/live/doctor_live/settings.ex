defmodule MedcerterWeb.DoctorLive.Settings do
  use MedcerterWeb, :live_view
  alias Medcerter.Settings

  @impl true
  def mount(_params, _session, socket) do
    socket_with_doctor_setting =
      assign_new(socket, :setting, fn ->
        Settings.get_doctor_setting_by_params(%{
          "doctor_id" => socket.assigns.current_doctor.id
        })
      end)

    {:ok, socket_with_doctor_setting}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
