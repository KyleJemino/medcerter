defmodule MedcerterWeb.DoctorLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView
  alias Medcerter.Accounts
  alias Medcerter.Patients

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

  def on_mount(:maybe_doctor_patient_auth, %{"id" => id}, _session, %{assigns: %{current_doctor: current_doctor}} = socket) do
    patient = Patients.get_patient(id)

    if patient.doctor_id === current_doctor.id do
      {:cont, assign(socket, :patient, patient)} 
    else 
      {:halt, redirect(socket, to: "/patients")}
    end
  end

  def on_mount(:maybe_doctor_patient_auth, _params, _session, socket) do
    {:cont, socket}
  end
end
