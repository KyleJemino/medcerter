defmodule MedcerterWeb.DoctorConfirmationControllerTest do
  use MedcerterWeb.ConnCase, async: true

  alias Medcerter.Accounts
  alias Medcerter.Repo
  import Medcerter.AccountsFixtures

  setup do
    %{doctor: doctor_fixture()}
  end

  describe "GET /doctors/confirm" do
    test "renders the resend confirmation page", %{conn: conn} do
      conn = get(conn, Routes.doctor_confirmation_path(conn, :new))
      response = html_response(conn, 200)
      assert response =~ "<h1>Resend confirmation instructions</h1>"
    end
  end

  describe "POST /doctors/confirm" do
    @tag :capture_log
    test "sends a new confirmation token", %{conn: conn, doctor: doctor} do
      conn =
        post(conn, Routes.doctor_confirmation_path(conn, :create), %{
          "doctor" => %{"email" => doctor.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.get_by!(Accounts.DoctorToken, doctor_id: doctor.id).context == "confirm"
    end

    test "does not send confirmation token if Doctor is confirmed", %{conn: conn, doctor: doctor} do
      Repo.update!(Accounts.Doctor.confirm_changeset(doctor))

      conn =
        post(conn, Routes.doctor_confirmation_path(conn, :create), %{
          "doctor" => %{"email" => doctor.email}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      refute Repo.get_by(Accounts.DoctorToken, doctor_id: doctor.id)
    end

    test "does not send confirmation token if email is invalid", %{conn: conn} do
      conn =
        post(conn, Routes.doctor_confirmation_path(conn, :create), %{
          "doctor" => %{"email" => "unknown@example.com"}
        })

      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "If your email is in our system"
      assert Repo.all(Accounts.DoctorToken) == []
    end
  end

  describe "GET /doctors/confirm/:token" do
    test "renders the confirmation page", %{conn: conn} do
      conn = get(conn, Routes.doctor_confirmation_path(conn, :edit, "some-token"))
      response = html_response(conn, 200)
      assert response =~ "<h1>Confirm account</h1>"

      form_action = Routes.doctor_confirmation_path(conn, :update, "some-token")
      assert response =~ "action=\"#{form_action}\""
    end
  end

  describe "POST /doctors/confirm/:token" do
    test "confirms the given token once", %{conn: conn, doctor: doctor} do
      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_confirmation_instructions(doctor, url)
        end)

      conn = post(conn, Routes.doctor_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :info) =~ "Doctor confirmed successfully"
      assert Accounts.get_doctor!(doctor.id).confirmed_at
      refute get_session(conn, :doctor_token)
      assert Repo.all(Accounts.DoctorToken) == []

      # When not logged in
      conn = post(conn, Routes.doctor_confirmation_path(conn, :update, token))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Doctor confirmation link is invalid or it has expired"

      # When logged in
      conn =
        build_conn()
        |> log_in_doctor(doctor)
        |> post(Routes.doctor_confirmation_path(conn, :update, token))

      assert redirected_to(conn) == "/"
      refute get_flash(conn, :error)
    end

    test "does not confirm email with invalid token", %{conn: conn, doctor: doctor} do
      conn = post(conn, Routes.doctor_confirmation_path(conn, :update, "oops"))
      assert redirected_to(conn) == "/"
      assert get_flash(conn, :error) =~ "Doctor confirmation link is invalid or it has expired"
      refute Accounts.get_doctor!(doctor.id).confirmed_at
    end
  end
end
