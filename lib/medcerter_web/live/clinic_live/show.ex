defmodule MedcerterWeb.ClinicLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Doctors
  alias Medcerter.Repo
  alias Medcerter.Clinics.Clinic

  @impl true
  def mount(params, _session, socket) do
    IO.inspect params
    {:ok, socket}
  end

  @impl true
  def handle_params(params, url, socket) do
    {:noreply, socket}
  end
end
