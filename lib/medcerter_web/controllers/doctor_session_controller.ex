defmodule MedcerterWeb.DoctorSessionController do
  use MedcerterWeb, :controller

  alias Medcerter.Accounts
  alias MedcerterWeb.DoctorAuth

  def new(conn, _params) do
    render(conn, "new.html", error_message: nil)
  end

  def create(conn, %{"doctor" => doctor_params}) do
    %{"email" => email, "password" => password} = doctor_params

    if doctor = Accounts.get_doctor_by_email_and_password(email, password) do
      DoctorAuth.log_in_doctor(conn, doctor, doctor_params)
    else
      # In order to prevent user enumeration attacks, don't disclose whether the email is registered.
      render(conn, "new.html", error_message: "Invalid email or password")
    end
  end

  def delete(conn, _params) do
    conn
    |> put_flash(:info, "Logged out successfully.")
    |> DoctorAuth.log_out_doctor()
  end
end
