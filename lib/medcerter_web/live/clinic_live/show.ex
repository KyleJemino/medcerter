defmodule MedcerterWeb.ClinicLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Doctors
  alias Medcerter.Repo
  alias Medcerter.Clinics

  alias Medcerter.Clinics.{
    Clinic,
    DoctorClinic
  }

  @impl true
  def mount(%{"clinic_id" => clinic_id}, _session, socket) do
    {:ok, assign_clinic(socket, clinic_id)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :index, _params) do
    socket
    |> assign(:page_title, "Clinic Dashboard")
    |> assign(:doctor_clinic, nil)
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "Add New Doctor")
    |> assign(:doctor_clinic, %DoctorClinic{clinic_id: socket.assigns.clinic.id})
  end

  def assign_clinic(socket, clinic_id) do
    assign_new(socket, :clinic, fn ->
      Clinics.get_clinic(clinic_id)
    end)
  end
end
