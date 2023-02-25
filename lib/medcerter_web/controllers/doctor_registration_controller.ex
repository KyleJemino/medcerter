defmodule MedcerterWeb.DoctorRegistrationController do
  use MedcerterWeb, :controller

  alias Medcerter.Accounts
  alias Medcerter.Accounts.Doctor
  alias MedcerterWeb.DoctorAuth

  def new(conn, _params) do
    changeset = Accounts.change_doctor_registration(%Doctor{})
    render(conn, "new.html", changeset: changeset)
  end

  def create(conn, %{"doctor" => doctor_params}) do
    case Accounts.register_doctor(doctor_params) do
      {:ok, doctor} ->
        {:ok, _} =
          Accounts.deliver_doctor_confirmation_instructions(
            doctor,
            &Routes.doctor_confirmation_url(conn, :edit, &1)
          )

        conn
        |> put_flash(:info, "Doctor created successfully.")
        |> DoctorAuth.log_in_doctor(doctor)

      {:error, %Ecto.Changeset{} = changeset} ->
        render(conn, "new.html", changeset: changeset)
    end
  end
end
