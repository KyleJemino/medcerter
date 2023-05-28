defmodule MedcerterWeb.PatientLive.ListWithSearchComponent do
  use MedcerterWeb, :live_component

  alias Medcerter.Patients

  @impl true
  def update(%{base_params: base_params} = assigns, socket) do
    IO.inspect base_params
    {:ok,
      socket
      |> assign(assigns)
      |> assign(:base_params, base_params)
      |> assign_patients()
    }
  end

  defp assign_patients(%{assigns: %{base_params: base_params}} = socket) do
    assign(socket, :patients, Patients.list_patients(base_params))
  end
end
