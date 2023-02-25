defmodule MedcerterWeb.DoctorConfirmationController do
  use MedcerterWeb, :controller

  alias Medcerter.Accounts

  def new(conn, _params) do
    render(conn, "new.html")
  end

  def create(conn, %{"doctor" => %{"email" => email}}) do
    if doctor = Accounts.get_doctor_by_email(email) do
      Accounts.deliver_doctor_confirmation_instructions(
        doctor,
        &Routes.doctor_confirmation_url(conn, :edit, &1)
      )
    end

    conn
    |> put_flash(
      :info,
      "If your email is in our system and it has not been confirmed yet, " <>
        "you will receive an email with instructions shortly."
    )
    |> redirect(to: "/")
  end

  def edit(conn, %{"token" => token}) do
    render(conn, "edit.html", token: token)
  end

  # Do not log in the doctor after confirmation to avoid a
  # leaked token giving the doctor access to the account.
  def update(conn, %{"token" => token}) do
    case Accounts.confirm_doctor(token) do
      {:ok, _} ->
        conn
        |> put_flash(:info, "Doctor confirmed successfully.")
        |> redirect(to: "/")

      :error ->
        # If there is a current doctor and the account was already confirmed,
        # then odds are that the confirmation link was already visited, either
        # by some automation or by the doctor themselves, so we redirect without
        # a warning message.
        case conn.assigns do
          %{current_doctor: %{confirmed_at: confirmed_at}} when not is_nil(confirmed_at) ->
            redirect(conn, to: "/")

          %{} ->
            conn
            |> put_flash(:error, "Doctor confirmation link is invalid or it has expired.")
            |> redirect(to: "/")
        end
    end
  end
end
