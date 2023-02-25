defmodule MedcerterWeb.DoctorResetPasswordController do
  use MedcerterWeb, :controller

  alias Medcerter.Accounts

  plug :get_doctor_by_reset_password_token when action in [:edit, :update]

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"doctor" => %{"email" => email}}) do
    if doctor = Accounts.get_doctor_by_email(email) do
      Accounts.deliver_doctor_reset_password_instructions(
        doctor,
        &Routes.doctor_reset_password_url(conn, :edit, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system, you will receive instructions to reset your password shortly."
    )
    |> redirect(to: "/")
  end

  def edit(conn, _params) do
    render(conn, "edit.html", changeset: Accounts.change_doctor_password(conn.assigns.doctor))
  end

  # Do not log in the doctor after reset password to avoid a
  # leaked token giving the doctor access to the account.
  def update(conn, %{"doctor" => doctor_params}) do
    case Accounts.reset_doctor_password(conn.assigns.doctor, doctor_params) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Password reset successfully.")
        |> redirect(to: Routes.doctor_session_path(conn, :new))

      {:error, changeset} ->
        render(conn, "edit.html", changeset: changeset)
    end
  end

  defp get_doctor_by_reset_password_token(conn, _opts) do
    %{"token" => token} = conn.params

    if doctor = Accounts.get_doctor_by_reset_password_token(token) do
      conn |> assign(:doctor, doctor) |> assign(:token, token)
    else
      conn
      |> put_flash(:error, "Reset password link is invalid or it has expired.")
      |> redirect(to: "/")
      |> halt()
    end
  end
end
