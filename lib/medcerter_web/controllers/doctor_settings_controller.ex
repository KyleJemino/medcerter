defmodule MedcerterWeb.DoctorSettingsController do
  use MedcerterWeb, :controller

  alias Medcerter.Accounts
  alias MedcerterWeb.DoctorAuth

  plug :assign_email_and_password_changesets

  def edit(conn, _params) do
    render(conn, "edit.html")
  end

  def update(conn, %{"action" => "update_email"} = params) do
    %{"current_password" => password, "doctor" => doctor_params} = params
    doctor = conn.assigns.current_doctor

    case Accounts.apply_doctor_email(doctor, password, doctor_params) do
      {:ok, applied_doctor} ->
        Accounts.deliver_update_email_instructions(
          applied_doctor,
          doctor.email,
          &Routes.doctor_settings_url(conn, :confirm_email, &1)
        )

        conn
        |> put_flash(
          :info,
          "A link to confirm your email change has been sent to the new address."
        )
        |> redirect(to: Routes.doctor_settings_path(conn, :edit))

      {:error, changeset} ->
        render(conn, "edit.html", email_changeset: changeset)
    end
  end

  def update(conn, %{"action" => "update_password"} = params) do
    %{"current_password" => password, "doctor" => doctor_params} = params
    doctor = conn.assigns.current_doctor

    case Accounts.update_doctor_password(doctor, password, doctor_params) do
      {:ok, doctor} ->
        conn
        |> put_flash(:info, "Password updated successfully.")
        |> put_session(:doctor_return_to, Routes.doctor_settings_path(conn, :edit))
        |> DoctorAuth.log_in_doctor(doctor)

      {:error, changeset} ->
        render(conn, "edit.html", password_changeset: changeset)
    end
  end

  def confirm_email(conn, %{"token" => token}) do
    case Accounts.update_doctor_email(conn.assigns.current_doctor, token) do
      :ok ->
        conn
        |> put_flash(:info, "Email changed successfully.")
        |> redirect(to: Routes.doctor_settings_path(conn, :edit))

      :error ->
        conn
        |> put_flash(:error, "Email change link is invalid or it has expired.")
        |> redirect(to: Routes.doctor_settings_path(conn, :edit))
    end
  end

  defp assign_email_and_password_changesets(conn, _opts) do
    doctor = conn.assigns.current_doctor

    conn
    |> assign(:email_changeset, Accounts.change_doctor_email(doctor))
    |> assign(:password_changeset, Accounts.change_doctor_password(doctor))
  end
end
