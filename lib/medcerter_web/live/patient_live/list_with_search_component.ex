defmodule MedcerterWeb.PatientLive.ListWithSearchComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Patients

  @impl true
  def update(
        %{
          base_params: base_params
        } = assigns,
        socket
      ) do
    search_params =
      if Map.has_key?(assigns, :search_params) do
        assigns.search_params
      else
        %{
          "first_name" => "",
          "last_name" => "",
          "middle_name" => ""
        }
      end

    {:ok,
     socket
     |> assign(:base_params, base_params)
     |> assign_search_params(search_params)
     |> assign_patients()}
  end

  @impl true
  def handle_event("search", %{"search_params" => search_params}, socket) do
    {:noreply,
     socket
     |> assign_search_params(search_params)
     |> assign_patients()}
  end

  defp assign_patients(
         %{
           assigns: %{
             base_params: base_params,
             search_params: search_params
           }
         } = socket
       ) do
    search_params_with_values =
      search_params
      |> Enum.filter(fn {_key, value} ->
        value !== ""
      end)
      |> Map.new()

    list_params = Map.merge(base_params, search_params_with_values)

    assign(socket, :patients, Patients.list_patients(list_params))
  end

  defp assign_search_params(socket, search_params) do
    assign(socket, :search_params, search_params)
  end
end
