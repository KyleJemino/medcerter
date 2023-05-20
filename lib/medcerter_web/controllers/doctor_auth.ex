defmodule MedcerterWeb.DoctorAuth do
  import Plug.Conn
  import Phoenix.Controller

  alias Medcerter.Accounts
  alias Medcerter.Accounts.Doctor
  alias Medcerter.Clinics
  alias MedcerterWeb.Router.Helpers, as: Routes

  # Make the remember me cookie valid for 60 days.
  # If you want bump or reduce this value, also change
  # the token expiry itself in DoctorToken.
  @max_age 60 * 60 * 24 * 60
  @remember_me_cookie "_medcerter_web_doctor_remember_me"
  @remember_me_options [sign: true, max_age: @max_age, same_site: "Lax"]

  @doc """
  Logs the doctor in.

  It renews the session ID and clears the whole session
  to avoid fixation attacks. See the renew_session
  function to customize this behaviour.

  It also sets a `:live_socket_id` key in the session,
  so LiveView sessions are identified and automatically
  disconnected on log out. The line can be safely removed
  if you are not using LiveView.
  """
  def log_in_doctor(conn, doctor, params \\ %{}) do
    token = Accounts.generate_doctor_session_token(doctor)
    doctor_return_to = get_session(conn, :doctor_return_to)

    conn
    |> renew_session()
    |> put_session(:doctor_token, token)
    |> put_session(:live_socket_id, "doctors_sessions:#{Base.url_encode64(token)}")
    |> maybe_write_remember_me_cookie(token, params)
    |> redirect(to: doctor_return_to || signed_in_path(conn, doctor))
  end

  defp maybe_write_remember_me_cookie(conn, token, %{"remember_me" => "true"}) do
    put_resp_cookie(conn, @remember_me_cookie, token, @remember_me_options)
  end

  defp maybe_write_remember_me_cookie(conn, _token, _params) do
    conn
  end

  # This function renews the session ID and erases the whole
  # session to avoid fixation attacks. If there is any data
  # in the session you may want to preserve after log in/log out,
  # you must explicitly fetch the session data before clearing
  # and then immediately set it after clearing, for example:
  #
  #     defp renew_session(conn) do
  #       preferred_locale = get_session(conn, :preferred_locale)
  #
  #       conn
  #       |> configure_session(renew: true)
  #       |> clear_session()
  #       |> put_session(:preferred_locale, preferred_locale)
  #     end
  #
  defp renew_session(conn) do
    conn
    |> configure_session(renew: true)
    |> clear_session()
  end

  @doc """
  Logs the doctor out.

  It clears all session data for safety. See renew_session.
  """
  def log_out_doctor(conn) do
    doctor_token = get_session(conn, :doctor_token)
    doctor_token && Accounts.delete_session_token(doctor_token)

    if live_socket_id = get_session(conn, :live_socket_id) do
      MedcerterWeb.Endpoint.broadcast(live_socket_id, "disconnect", %{})
    end

    conn
    |> renew_session()
    |> delete_resp_cookie(@remember_me_cookie)
    |> redirect(to: "/")
  end

  @doc """
  Authenticates the doctor by looking into the session
  and remember me token.
  """
  def fetch_current_doctor(conn, _opts) do
    {doctor_token, conn} = ensure_doctor_token(conn)
    doctor = doctor_token && Accounts.get_doctor_by_session_token(doctor_token)
    assign(conn, :current_doctor, doctor)
  end

  defp ensure_doctor_token(conn) do
    if doctor_token = get_session(conn, :doctor_token) do
      {doctor_token, conn}
    else
      conn = fetch_cookies(conn, signed: [@remember_me_cookie])

      if doctor_token = conn.cookies[@remember_me_cookie] do
        {doctor_token, put_session(conn, :doctor_token, doctor_token)}
      else
        {nil, conn}
      end
    end
  end

  @doc """
  Used for routes that require the doctor to not be authenticated.
  """
  def redirect_if_doctor_is_authenticated(conn, _opts) do
    if conn.assigns[:current_doctor] do
      conn
      |> redirect(to: signed_in_path(conn))
      |> halt()
    else
      conn
    end
  end

  @doc """
  Used for routes that require the doctor to be authenticated.

  If you want to enforce the doctor email is confirmed before
  they use the application at all, here would be a good place.
  """
  def require_authenticated_doctor(conn, _opts) do
    if conn.assigns[:current_doctor] do
      conn
    else
      conn
      |> put_flash(:error, "You must log in to access this page.")
      |> maybe_store_return_to()
      |> redirect(to: Routes.doctor_session_path(conn, :new))
      |> halt()
    end
  end

  defp maybe_store_return_to(%{method: "GET"} = conn) do
    put_session(conn, :doctor_return_to, current_path(conn))
  end

  defp maybe_store_return_to(conn), do: conn

  defp signed_in_path(conn, %Doctor{} = doctor) do
    clinics = 
      Clinics.list_clinics(%{
        "doctor_id" => doctor.id,
        "limit" => 2
      })

    case clinics do
      [clinic | []] ->
        Routes.patient_index_path(conn, :index, clinic)
      _ ->
        signed_in_path(conn)
    end
  end

  defp signed_in_path(conn), do: Routes.clinic_index_path(conn, :index)
end
