defmodule MedcerterWeb.PatientLive.ListWithSearchComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Patients

  @impl true
  def update(%{base_params: base_params} = assigns, socket) do
    {:ok,
      socket
      |> assign(assigns)
      |> assign(:base_params, base_params)
      |> assign(:search_params, %{}) 
      |> assign_patients()
    }
  end

  def handle_event("search", %{ "search_params" => search_params }, socket) do
    {:noreply, 
      socket
      |> assign_search_params(search_params)
      |> assign_patients()
    }
  end

  defp assign_patients(%{
    assigns: %{
      base_params: base_params,
      search_params: search_params
    }
  } = socket) do
    list_params = Map.merge(base_params, search_params)

    assign(socket, :patients, Patients.list_patients(list_params))
  end

  defp assign_search_params(socket, search_params) do
    search_params_with_values = 
      search_params 
      |> Enum.filter(
        fn {_key, value} -> 
          value !== ""
        end
      )
      |> Map.new()

    assign(socket, :search_params, search_params)
  end
end
