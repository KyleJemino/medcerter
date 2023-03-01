defmodule MedcerterWeb.DoctorAuthTest do
  use MedcerterWeb.ConnCase, async: true

  alias Medcerter.Accounts
  alias MedcerterWeb.DoctorAuth
  import Medcerter.AccountsFixtures

  @remember_me_cookie "_medcerter_web_doctor_remember_me"

  setup %{conn: conn} do
    conn =
      conn
      |> Map.replace!(:secret_key_base, MedcerterWeb.Endpoint.config(:secret_key_base))
      |> init_test_session(%{})

    %{doctor: doctor_fixture(), conn: conn}
  end

  describe "log_in_doctor/3" do
    test "stores the doctor token in the session", %{conn: conn, doctor: doctor} do
      conn = DoctorAuth.log_in_doctor(conn, doctor)
      assert token = get_session(conn, :doctor_token)
      assert get_session(conn, :live_socket_id) == "doctors_sessions:#{Base.url_encode64(token)}"
      assert redirected_to(conn) == "/"
      assert Accounts.get_doctor_by_session_token(token)
    end

    test "clears everything previously stored in the session", %{conn: conn, doctor: doctor} do
      conn = conn |> put_session(:to_be_removed, "value") |> DoctorAuth.log_in_doctor(doctor)
      refute get_session(conn, :to_be_removed)
    end

    test "redirects to the configured path", %{conn: conn, doctor: doctor} do
      conn = conn |> put_session(:doctor_return_to, "/hello") |> DoctorAuth.log_in_doctor(doctor)
      assert redirected_to(conn) == "/hello"
    end

    test "writes a cookie if remember_me is configured", %{conn: conn, doctor: doctor} do
      conn =
        conn |> fetch_cookies() |> DoctorAuth.log_in_doctor(doctor, %{"remember_me" => "true"})

      assert get_session(conn, :doctor_token) == conn.cookies[@remember_me_cookie]

      assert %{value: signed_token, max_age: max_age} = conn.resp_cookies[@remember_me_cookie]
      assert signed_token != get_session(conn, :doctor_token)
      assert max_age == 5_184_000
    end
  end

  describe "logout_doctor/1" do
    test "erases session and cookies", %{conn: conn, doctor: doctor} do
      doctor_token = Accounts.generate_doctor_session_token(doctor)

      conn =
        conn
        |> put_session(:doctor_token, doctor_token)
        |> put_req_cookie(@remember_me_cookie, doctor_token)
        |> fetch_cookies()
        |> DoctorAuth.log_out_doctor()

      refute get_session(conn, :doctor_token)
      refute conn.cookies[@remember_me_cookie]
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == "/"
      refute Accounts.get_doctor_by_session_token(doctor_token)
    end

    test "broadcasts to the given live_socket_id", %{conn: conn} do
      live_socket_id = "doctors_sessions:abcdef-token"
      MedcerterWeb.Endpoint.subscribe(live_socket_id)

      conn
      |> put_session(:live_socket_id, live_socket_id)
      |> DoctorAuth.log_out_doctor()

      assert_receive %Phoenix.Socket.Broadcast{event: "disconnect", topic: ^live_socket_id}
    end

    test "works even if doctor is already logged out", %{conn: conn} do
      conn = conn |> fetch_cookies() |> DoctorAuth.log_out_doctor()
      refute get_session(conn, :doctor_token)
      assert %{max_age: 0} = conn.resp_cookies[@remember_me_cookie]
      assert redirected_to(conn) == "/"
    end
  end

  describe "fetch_current_doctor/2" do
    test "authenticates doctor from session", %{conn: conn, doctor: doctor} do
      doctor_token = Accounts.generate_doctor_session_token(doctor)

      conn =
        conn |> put_session(:doctor_token, doctor_token) |> DoctorAuth.fetch_current_doctor([])

      assert conn.assigns.current_doctor.id == doctor.id
    end

    test "authenticates doctor from cookies", %{conn: conn, doctor: doctor} do
      logged_in_conn =
        conn |> fetch_cookies() |> DoctorAuth.log_in_doctor(doctor, %{"remember_me" => "true"})

      doctor_token = logged_in_conn.cookies[@remember_me_cookie]
      %{value: signed_token} = logged_in_conn.resp_cookies[@remember_me_cookie]

      conn =
        conn
        |> put_req_cookie(@remember_me_cookie, signed_token)
        |> DoctorAuth.fetch_current_doctor([])

      assert get_session(conn, :doctor_token) == doctor_token
      assert conn.assigns.current_doctor.id == doctor.id
    end

    test "does not authenticate if data is missing", %{conn: conn, doctor: doctor} do
      _ = Accounts.generate_doctor_session_token(doctor)
      conn = DoctorAuth.fetch_current_doctor(conn, [])
      refute get_session(conn, :doctor_token)
      refute conn.assigns.current_doctor
    end
  end

  describe "redirect_if_doctor_is_authenticated/2" do
    test "redirects if doctor is authenticated", %{conn: conn, doctor: doctor} do
      conn =
        conn
        |> assign(:current_doctor, doctor)
        |> DoctorAuth.redirect_if_doctor_is_authenticated([])

      assert conn.halted
      assert redirected_to(conn) == "/"
    end

    test "does not redirect if doctor is not authenticated", %{conn: conn} do
      conn = DoctorAuth.redirect_if_doctor_is_authenticated(conn, [])
      refute conn.halted
      refute conn.status
    end
  end

  describe "require_authenticated_doctor/2" do
    test "redirects if doctor is not authenticated", %{conn: conn} do
      conn = conn |> fetch_flash() |> DoctorAuth.require_authenticated_doctor([])
      assert conn.halted
      assert redirected_to(conn) == Routes.doctor_session_path(conn, :new)
      assert get_flash(conn, :error) == "You must log in to access this page."
    end

    test "stores the path to redirect to on GET", %{conn: conn} do
      halted_conn =
        %{conn | path_info: ["foo"], query_string: ""}
        |> fetch_flash()
        |> DoctorAuth.require_authenticated_doctor([])

      assert halted_conn.halted
      assert get_session(halted_conn, :doctor_return_to) == "/foo"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar=baz"}
        |> fetch_flash()
        |> DoctorAuth.require_authenticated_doctor([])

      assert halted_conn.halted
      assert get_session(halted_conn, :doctor_return_to) == "/foo?bar=baz"

      halted_conn =
        %{conn | path_info: ["foo"], query_string: "bar", method: "POST"}
        |> fetch_flash()
        |> DoctorAuth.require_authenticated_doctor([])

      assert halted_conn.halted
      refute get_session(halted_conn, :doctor_return_to)
    end

    test "does not redirect if doctor is authenticated", %{conn: conn, doctor: doctor} do
      conn =
        conn |> assign(:current_doctor, doctor) |> DoctorAuth.require_authenticated_doctor([])

      refute conn.halted
      refute conn.status
    end
  end
end
