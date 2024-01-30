defmodule MedcerterWeb.PrescriptionLive.FormComponent do
  use MedcerterWeb, :live_component
  alias Ecto.Changeset

  alias Medcerter.Prescriptions
  alias Medcerter.Prescriptions.Medicine

  @impl true
  def update(assigns, socket) do
    changeset = Prescriptions.change_prescription(assigns.prescription)

    {
      :ok,
      socket
      |> assign(assigns)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"prescription" => prescription_params}, socket) do
    changeset =
      socket.assigns.prescription
      |> Prescriptions.change_prescription(prescription_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"prescription" => prescription_params}, socket) do
    save_prescription(socket, socket.assigns.action, prescription_params)
  end

  @impl true
  def handle_event("add-medicine", _, socket) do
    current_changeset = socket.assigns.changeset
    current_medicines = Changeset.fetch_field!(current_changeset, :medicines)

    updated_changeset =
      Changeset.put_embed(
        current_changeset,
        :medicines,
        (current_medicines || []) ++
          [
            %Medicine{
              id: Ecto.UUID.generate()
            }
          ]
      )

    {:noreply, assign(socket, :changeset, updated_changeset)}
  end

  @impl true
  def handle_event("delete-medicine", %{"medicine-id" => medicine_id}, socket) do
    changeset = socket.assigns.changeset

    updated_medicines =
      changeset
      |> Changeset.fetch_field!(:medicines)
      |> Enum.reject(fn medicine ->
        medicine.id === medicine_id
      end)

    updated_changeset =
      Changeset.put_embed(changeset, :medicines, updated_medicines)

    {:noreply, assign(socket, :changeset, updated_changeset)}
  end

  defp save_prescription(socket, :new, prescription_params) do
    case Prescriptions.create_prescription(prescription_params) do
      {:ok, _prescription} ->
        {:noreply,
         socket
         |> put_flash(:info, "Prescription created")
         |> push_patch(to: socket.assigns.return_to)}

      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end
end
