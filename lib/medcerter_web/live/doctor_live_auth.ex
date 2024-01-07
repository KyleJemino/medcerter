defmodule MedcerterWeb.DoctorLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView

  alias Medcerter.{
    Accounts,
    Patients
  }
  alias Accounts.Doctor
  alias Patients.{
    Patient,
    DoctorPatient
  }

  def on_mount(:default, _params, session, socket) do
    %{"doctor_token" => doctor_token} = session

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

  def on_mount(
    :maybe_doctor_patient_auth,
    %{"patient_id" => patient_id},
    _session,
    socket
  ) do
    with %Doctor{id: doctor_id} <- socket.assigns.current_doctor,
      %DoctorPatient{} = _doctor_patient <- Patients.get_doctor_patient(%{
        "doctor_id" => doctor_id,
        "patient_id" => patient_id
      }), 
      %Patient{} = patient <- Patients.get_patient(patient_id, %{"preload" => :visits}) 
    do
      {:cont, assign(socket, :patient, patient)}
    else
      _ -> {:halt, redirect(socket, to: "/patients")}
    end
  end

  def on_mount(:maybe_doctor_patient_auth, _params, _session, socket) do
    {:cont, socket}
  end
end
