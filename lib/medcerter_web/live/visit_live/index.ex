defmodule MedcerterWeb.VisitLive.Index do
  use MedcerterWeb, :live_view

  def mount(socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(
    %{
      assigns: %{
        current_clinic: current_clinic,
        current_doctor: current_doctor,
        patient: patient
      }    
    } = socket, 
    :new, 
    _params
  ) do
    socket
    |> assign(:visit, %Visit{
      clinic_id: current_clinic.id,
      doctor_id: current_doctor.id,
      patient_id: patient.id
    })
  end

  defp apply_action(
    %{
      assigns: %{
        current_clinic: current_clinic,
        current_doctor: current_doctor,
        patient: patient
      }    
    } = socket, 
    :edit, 
    _params
  ) do
    socket
    |> assign(:visit, %Visit{
      clinic_id: current_clinic.id,
      doctor_id: current_doctor.id,
      patient_id: patient.id
    })
  end
end
