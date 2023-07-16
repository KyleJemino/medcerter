defmodule MedcerterWeb.VisitLive.Index do
  use MedcerterWeb, :live_view

  def mount(socket) do
    {:ok, socket}
  end

  def handle_params(_params, _url, socket) do
    {:noreply, socket}
  end
end
