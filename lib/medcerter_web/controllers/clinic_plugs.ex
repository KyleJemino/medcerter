defmodule MedcerterWeb.ClinicAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias MedcerterWeb.Router.Helpers, as: Routes
  alias Medcerter.Clinics
  alias Medcerter.Clinics.DoctorClinic


  def maybe_fetch_current_clinic(%{ 
    assigns: %{current_doctor: doctor} , 
    params: %{"clinic_id" => clinic_id}
  } = conn, _opts) do
    case Clinics.get_doctor_clinic(%{
      "clinic_id" => clinic_id,
      "doctor_id" => doctor.id,
      "preload" => :clinic
    }) do
      %DoctorClinic{} = doctor_clinic ->
        assign(conn, :current_clinic, doctor_clinic.clinic)
      _ ->
        assign(conn, :current_clinic, nil)
    end
  end

  def maybe_fetch_current_clinic(conn, _opts) do
    assign(conn, :current_clinic, nil)
  end
end
