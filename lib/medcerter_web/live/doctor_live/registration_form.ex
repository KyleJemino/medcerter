defmodule MedcerterWeb.DoctorLive.RegistrationForm do
  use MedcerterWeb, :live_component

  alias Ecto.Changeset
  alias Medcerter.Accounts
  alias Accounts.ContactInformation

  @impl true
  def update(assigns, socket) do
    changeset = Accounts.change_doctor_registration(assigns.doctor)
    {
      :ok,
      socket
      |> assign(:doctor, assigns.doctor)
      |> assign(:changeset, changeset)
    }
  end

  @impl true
  def handle_event("validate", %{"doctor" => doctor_params}, socket) do
    changeset =
      socket.assigns.doctor
      |> Accounts.change_doctor_registration(doctor_params)
      |> Map.put(:action, :validate)

    {:noreply, assign(socket, :changeset, changeset)}
  end

  @impl true
  def handle_event("save", %{"doctor" => doctor_params}, socket) do
    case Accounts.register_doctor(doctor_params) do
      {:ok, _doctor} ->
        {:noreply,
          socket
          |> put_flash(:info, "Registered successfully")
          |> push_redirect(
            to:
            Routes.doctor_session_path(socket, :new)
          )
        }
      {:error, changeset} ->
        {:noreply, assign(socket, :changeset, changeset)}
    end
  end

  @impl true
  def handle_event("add-contact-info", _, socket) do
    current_changeset = socket.assigns.changeset
    current_contacts = Changeset.fetch_field!(current_changeset, :contact_information)

    updated_changeset =
      Changeset.put_embed(
        current_changeset,
        :contact_information,
        (current_contacts || []) ++
          [
            %ContactInformation{
              id: Ecto.UUID.generate()
            }
          ]
      )

    {:noreply, assign(socket, :changeset, updated_changeset)}
  end

  @impl true
  def handle_event("delete-info", %{"info-id" => info_id}, socket) do
    changeset = socket.assigns.changeset

    updated_infos =
      changeset
      |> Changeset.fetch_field!(:contact_information)
      |> Enum.reject(fn info ->
        info.id === info_id
      end)

    updated_changeset =
      Changeset.put_embed(changeset, :contact_information, updated_infos)

    {:noreply, assign(socket, :changeset, updated_changeset)}
  end
end
