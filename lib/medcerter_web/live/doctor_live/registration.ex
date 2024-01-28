defmodule MedcerterWeb.DoctorLive.Registration do
  use MedcerterWeb, :live_view

  alias Medcerter.Accounts.Doctor

  def mount(_params, _session, socket) do
    {:ok,
     socket
     |> assign(:doctor, %Doctor{})}
  end
end
