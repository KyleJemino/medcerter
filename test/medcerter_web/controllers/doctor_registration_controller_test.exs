defmodule MedcerterWeb.DoctorRegistrationControllerTest do
  use MedcerterWeb.ConnCase, async: true

  import Medcerter.AccountsFixtures

  describe "GET /doctors/register" do
    test "renders registration page", %{conn: conn} do
      conn = get(conn, Routes.doctor_registration_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "Log in</a>"
      assert response =~ "Register</a>"
    end

    test "redirects if already logged in", %{conn: conn} do
      conn = conn |> log_in_doctor(doctor_fixture()) |> get(Routes.doctor_registration_path(conn, :new))
      assert redirected_to(conn) == "/"
    end
  end

  describe "POST /doctors/register" do
    @tag :capture_log
    test "creates account and logs the doctor in", %{conn: conn} do
      email = unique_doctor_email()

      conn =
        post(conn, Routes.doctor_registration_path(conn, :create), %{
          "doctor" => valid_doctor_attributes(email: email)
        })

      assert get_session(conn, :doctor_token)
      assert redirected_to(conn) == "/"

      # Now do a logged in request and assert on the menu
      conn = get(conn, "/")
      response = html_response(conn, 200)
      assert response =~ email
      assert response =~ "Settings</a>"
      assert response =~ "Log out</a>"
    end

    test "render errors for invalid data", %{conn: conn} do
      conn =
        post(conn, Routes.doctor_registration_path(conn, :create), %{
          "doctor" => %{"email" => "with spaces", "password" => "too short"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Register</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "should be at least 12 character"
    end
  end
end
