defmodule MedcerterWeb.DoctorLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView
  alias Medcerter.Accounts

  def on_mount(:default, _params, %{"doctor_token" => doctor_token} = _session, socket) do
    socket =
      assign_new(socket, :current_doctor, fn -> 
        Accounts.get_doctor_by_session_token(doctor_token)
      end)

    if socket.assigns.current_doctor do
      {:cont, socket}
    else
      {:halt, redirect(socket, to: "/login")}
    end
  end
end
