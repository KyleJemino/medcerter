defmodule MedcerterWeb.DoctorSessionControllerTest do
  use MedcerterWeb.ConnCase, async: true

  import Medcerter.AccountsFixtures

  setup do
    %{doctor: doctor_fixture()}
  end

  describe "GET /doctors/log_in" do
    test "renders log in page", %{conn: conn} do
      conn = get(conn, Routes.doctor_session_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Register</a>"
      assert response =~ "Forgot your password?</a>"
    end

    test "redirects if already logged in", %{conn: conn, doctor: doctor} do
      conn = conn |> log_in_doctor(doctor) |> get(Routes.doctor_session_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /doctors/log_in" do
    test "logs the doctor in", %{conn: conn, doctor: doctor} do
      conn =
        post(conn, Routes.doctor_session_path(conn, :create), %{
          "doctor" => %{"email" => doctor.email, "password" => valid_doctor_password()}
        })

      assert get_session(conn, :doctor_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ doctor.email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "logs the doctor in with remember me", %{conn: conn, doctor: doctor} do
      conn =
        post(conn, Routes.doctor_session_path(conn, :create), %{
          "doctor" => %{
            "email" => doctor.email,
            "password" => valid_doctor_password(),
            "remember_me" => "true"
          }
        })

      assert conn.resp_cookies["_medcerter_web_doctor_remember_me"]
      assert redirected_to(conn) == "/"
    end

    test "logs the doctor in with return to", %{conn: conn, doctor: doctor} do
      conn =
        conn
        |> init_test_session(doctor_return_to: "/foo/bar")
        |> post(Routes.doctor_session_path(conn, :create), %{
          "doctor" => %{
            "email" => doctor.email,
            "password" => valid_doctor_password()
          }
        })

      assert redirected_to(conn) == "/foo/bar"
    end

    test "emits error message with invalid credentials", %{conn: conn, doctor: doctor} do
      conn =
        post(conn, Routes.doctor_session_path(conn, :create), %{
          "doctor" => %{"email" => doctor.email, "password" => "invalid_password"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Log in</h1>"
      assert response =~ "Invalid email or password"
    end
  end

  describe "DELETE /doctors/log_out" do
    test "logs the doctor out", %{conn: conn, doctor: doctor} do
      conn = conn |> log_in_doctor(doctor) |> delete(Routes.doctor_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :doctor_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end

    test "succeeds even if the doctor is not logged in", %{conn: conn} do
      conn = delete(conn, Routes.doctor_session_path(conn, :delete))
      assert redirected_to(conn) == "/"
      refute get_session(conn, :doctor_token)
      assert get_flash(conn, :info) =~ "Logged out successfully"
    end
  end
end
