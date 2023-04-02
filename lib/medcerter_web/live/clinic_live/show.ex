defmodule MedcerterWeb.ClinicLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Doctors
  alias Medcerter.Repo
  alias Medcerter.Clinics.Clinic
  alias Medcerter.Clinics

  @impl true
  def mount(%{"clinic_id" => clinic_id}, _session, socket) do
    {:ok, assign_clinic(socket, clinic_id)}
  end

  @impl true
  def handle_params(params, url, socket) do
    {:noreply, socket}
  end

  def assign_clinic(socket, clinic_id) do
    assign_new(socket, :clinic, fn ->
      Clinics.get_clinic(clinic_id)
    end)
  end
end
