defmodule MedcerterWeb.ClinicLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Doctors
  alias Medcerter.Repo
  alias Medcerter.Clinics.Clinic

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, url, socket) do
    IO.inspect params
    IO.inspect url
    {:noreply, socket}
  end
end
