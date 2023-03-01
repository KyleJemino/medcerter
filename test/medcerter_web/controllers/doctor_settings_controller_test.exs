defmodule MedcerterWeb.DoctorSettingsControllerTest do
  use MedcerterWeb.ConnCase, async: true

  alias Medcerter.Accounts
  import Medcerter.AccountsFixtures

  setup :register_and_log_in_doctor

  describe "GET /doctors/settings" do
    test "renders settings page", %{conn: conn} do
      conn = get(conn, Routes.doctor_settings_path(conn, :edit))
      response = html_response(conn, 200)
      assert response =~ "<h1>Settings</h1>"
    end

    test "redirects if doctor is not logged in" do
      conn = build_conn()
      conn = get(conn, Routes.doctor_settings_path(conn, :edit))
      assert redirected_to(conn) == Routes.doctor_session_path(conn, :new)
    end
  end

  describe "PUT /doctors/settings (change password form)" do
    test "updates the doctor password and resets tokens", %{conn: conn, doctor: doctor} do
      new_password_conn =
        put(conn, Routes.doctor_settings_path(conn, :update), %{
          "action" => "update_password",
          "current_password" => valid_doctor_password(),
          "doctor" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(new_password_conn) == Routes.doctor_settings_path(conn, :edit)
      assert get_session(new_password_conn, :doctor_token) != get_session(conn, :doctor_token)
      assert get_flash(new_password_conn, :info) =~ "Password updated successfully"
      assert Accounts.get_doctor_by_email_and_password(doctor.email, "new valid password")
    end

    test "does not update password on invalid data", %{conn: conn} do
      old_password_conn =
        put(conn, Routes.doctor_settings_path(conn, :update), %{
          "action" => "update_password",
          "current_password" => "invalid",
          "doctor" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(old_password_conn, 200)
      assert response =~ "<h1>Settings</h1>"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
      assert response =~ "is not valid"

      assert get_session(old_password_conn, :doctor_token) == get_session(conn, :doctor_token)
    end
  end

  describe "PUT /doctors/settings (change email form)" do
    @tag :capture_log
    test "updates the doctor email", %{conn: conn, doctor: doctor} do
      conn =
        put(conn, Routes.doctor_settings_path(conn, :update), %{
          "action" => "update_email",
          "current_password" => valid_doctor_password(),
          "doctor" => %{"email" => unique_doctor_email()}
        })

      assert redirected_to(conn) == Routes.doctor_settings_path(conn, :edit)
      assert get_flash(conn, :info) =~ "A link to confirm your email"
      assert Accounts.get_doctor_by_email(doctor.email)
    end

    test "does not update email on invalid data", %{conn: conn} do
      conn =
        put(conn, Routes.doctor_settings_path(conn, :update), %{
          "action" => "update_email",
          "current_password" => "invalid",
          "doctor" => %{"email" => "with spaces"}
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Settings</h1>"
      assert response =~ "must have the @ sign and no spaces"
      assert response =~ "is not valid"
    end
  end

  describe "GET /doctors/settings/confirm_email/:token" do
    setup %{doctor: doctor} do
      email = unique_doctor_email()

      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_update_email_instructions(%{doctor | email: email}, doctor.email, url)
        end)

      %{token: token, email: email}
    end

    test "updates the doctor email once", %{
      conn: conn,
      doctor: doctor,
      token: token,
      email: email
    } do
      conn = get(conn, Routes.doctor_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.doctor_settings_path(conn, :edit)
      assert get_flash(conn, :info) =~ "Email changed successfully"
      refute Accounts.get_doctor_by_email(doctor.email)
      assert Accounts.get_doctor_by_email(email)

      conn = get(conn, Routes.doctor_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.doctor_settings_path(conn, :edit)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
    end

    test "does not update email with invalid token", %{conn: conn, doctor: doctor} do
      conn = get(conn, Routes.doctor_settings_path(conn, :confirm_email, "oops"))
      assert redirected_to(conn) == Routes.doctor_settings_path(conn, :edit)
      assert get_flash(conn, :error) =~ "Email change link is invalid or it has expired"
      assert Accounts.get_doctor_by_email(doctor.email)
    end

    test "redirects if doctor is not logged in", %{token: token} do
      conn = build_conn()
      conn = get(conn, Routes.doctor_settings_path(conn, :confirm_email, token))
      assert redirected_to(conn) == Routes.doctor_session_path(conn, :new)
    end
  end
end
