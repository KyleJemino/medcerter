defmodule MedcerterWeb.ClinicLive.Index do
  use MedcerterWeb, :live_view

  alias Medcerter.Doctors
  alias Medcerter.Repo
  alias Medcerter.Clinics.Clinic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, preload_clinics(socket)}
  end

  @impl true
  def handle_params(_params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action)}
  end

  def apply_action(socket, :index) do
    assign(socket, :page_title, "Clinic List")
  end

  def apply_action(socket, :new) do
    socket
    |> assign(:page_title, "New Clinic")
    |> assign(:clinic, %Clinic{doctor_id: socket.assigns.current_doctor.id})
  end

  defp preload_clinics(%{assigns: %{current_doctor: doctor}} = socket) do
    assign(socket, :current_doctor, Repo.preload(doctor, :clinics))
  end
end
