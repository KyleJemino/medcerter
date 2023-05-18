defmodule MedcerterWeb.DoctorLiveAuth do
  import Phoenix.Component
  import Phoenix.LiveView

  alias Medcerter.{
    Accounts,
    Patients,
    Clinics
  }

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

  def on_mount(
        :maybe_doctor_clinic_auth,
        %{"clinic_id" => clinic_id},
        _session,
        %{assigns: %{current_doctor: current_doctor}} = socket
      ) do
    doctor_clinic =
      Clinics.get_doctor_clinic(%{
        "clinic_id" => clinic_id,
        "doctor_id" => current_doctor.id,
        "preload" => :clinic
      })

    if not is_nil(doctor_clinic) do
      {:cont, assign(socket, :current_clinic, doctor_clinic.clinic)}
    else
      {:halt, redirect(socket, to: "/clinics")}
    end
  end

  def on_mount(:maybe_doctor_clinic_auth, _params, _session, socket) do
    {:cont, socket}
  end

  def on_mount(
        :maybe_clinic_patient_auth,
        %{"patient_id" => id},
        _session,
        %{assigns: %{current_clinic: clinic}} = socket
      ) do
    patient = Patients.get_patient(id)

    if patient.clinic_id === clinic.id do
      {:cont, assign(socket, :patient, patient)}
    else
      {:halt, redirect(socket, to: "/patients")}
    end
  end

  def on_mount(:maybe_clinic_patient_auth, _params, _session, socket) do
    {:cont, socket}
  end
end
