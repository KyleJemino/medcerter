defmodule MedcerterWeb.DoctorResetPasswordControllerTest do
  use MedcerterWeb.ConnCase, async: true

  alias Medcerter.Accounts
  alias Medcerter.Repo
  import Medcerter.AccountsFixtures

  setup do
    %{doctor: doctor_fixture()}
  end

  describe "GET /doctors/reset_password" do
    test "renders the reset password page", %{conn: conn} do
      conn = get(conn, Routes.doctor_reset_password_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Forgot your password?</h1>"
    end
  end

  describe "POST /doctors/reset_password" do
    @tag :capture_log
    test "sends a new reset password token", %{conn: conn, doctor: doctor} do
      conn =
        post(conn, Routes.doctor_reset_password_path(conn, :create), %{
          "doctor" => %{"email" => doctor.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(Accounts.DoctorToken, doctor_id: doctor.id).context == "reset_password"
    end

    test "does not send reset password token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.doctor_reset_password_path(conn, :create), %{
          "doctor" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(Accounts.DoctorToken) == []
    end
  end

  describe "GET /doctors/reset_password/:token" do
    setup %{doctor: doctor} do
      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_reset_password_instructions(doctor, url)
        end)

      %{token: token}
    end

    test "renders reset password", %{conn: conn, token: token} do
      conn = get(conn, Routes.doctor_reset_password_path(conn, :edit, token))
      assert html_response(conn, 200) =~ "<h1>Reset password</h1>"
    end

    test "does not render reset password with invalid token", %{conn: conn} do
      conn = get(conn, Routes.doctor_reset_password_path(conn, :edit, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end

  describe "PUT /doctors/reset_password/:token" do
    setup %{doctor: doctor} do
      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_reset_password_instructions(doctor, url)
        end)

      %{token: token}
    end

    test "resets password once", %{conn: conn, doctor: doctor, token: token} do
      conn =
        put(conn, Routes.doctor_reset_password_path(conn, :update, token), %{
          "doctor" => %{
            "password" => "new valid password",
            "password_confirmation" => "new valid password"
          }
        })

      assert redirected_to(conn) == Routes.doctor_session_path(conn, :new)
      refute get_session(conn, :doctor_token)
      assert get_flash(conn, :info) =~ "Password reset successfully"
      assert Accounts.get_doctor_by_email_and_password(doctor.email, "new valid password")
    end

    test "does not reset password on invalid data", %{conn: conn, token: token} do
      conn =
        put(conn, Routes.doctor_reset_password_path(conn, :update, token), %{
          "doctor" => %{
            "password" => "too short",
            "password_confirmation" => "does not match"
          }
        })

      response = html_response(conn, 200)
      assert response =~ "<h1>Reset password</h1>"
      assert response =~ "should be at least 12 character(s)"
      assert response =~ "does not match password"
    end

    test "does not reset password with invalid token", %{conn: conn} do
      conn = put(conn, Routes.doctor_reset_password_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Reset password link is invalid or it has expired"
    end
  end
end
