defmodule MedcerterWeb.VisitLive.Show do
  use MedcerterWeb, :live_view

  alias Medcerter.Visits

  alias MedcerterWeb.Components.{
    VisitComponents,
    PrescriptionComponents
  }

  alias Medcerter.Prescriptions

  alias Medcerter.Prescriptions.{
    Prescription,
    Medicine
  }

  @impl true
  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  @impl true
  def handle_params(params, _url, socket) do
    %{"visit_id" => visit_id} = params

    visit =
      Visits.get_visit_by_params(%{
        "id" => visit_id
      })

    prescriptions =
      Prescriptions.list_prescriptions(%{
        "visit_id" => visit_id
      })

    {:noreply,
     socket
     |> assign(:visit, visit)
     |> assign(:prescriptions, prescriptions)
     |> assign_title(socket.assigns.live_action)
     |> assign_prescription(socket.assigns.live_action, params)}
  end

  @impl true
  def handle_event("delete-prescription", %{"prescription-id" => prescription_id}, socket) do
    %{
      patient: patient,
      visit: visit
    } = socket.assigns

    prescription_id
    |> Prescriptions.get_prescription()
    |> Prescriptions.archive_prescription()

    {:noreply, push_patch(socket, to: Routes.visit_show_path(socket, :show, patient, visit))}
  end

  defp assign_title(socket, :show) do
    socket
    |> assign(:page_title, "Visit")
  end

  defp assign_title(socket, :edit) do
    socket
    |> assign(:page_title, "Edit Visit")
  end

  defp assign_title(socket, :new_prescription) do
    socket
    |> assign(:page_title, "New Prescription")
  end

  defp assign_title(socket, :edit_prescription) do
    socket
    |> assign(:page_title, "Edit Prescription")
  end

  defp assign_prescription(socket, :new_prescription, _params) do
    socket
    |> assign(:prescription, %Prescription{
      visit_id: socket.assigns.visit.id,
      doctor_id: socket.assigns.current_doctor.id,
      patient_id: socket.assigns.patient.id,
      medicines: [%Medicine{
        id: Ecto.UUID.generate()
      }]
    })
  end

  defp assign_prescription(socket, :edit_prescription, %{"prescription_id" => prescription_id}) do
    socket
    |> assign(:prescription, Prescriptions.get_prescription(prescription_id))
  end

  defp assign_prescription(socket, _, _), do: assign(socket, :prescription, nil)
end
