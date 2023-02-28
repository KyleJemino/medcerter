defmodule Medcerter.AccountsTest do
  use Medcerter.DataCase

  alias Medcerter.Accounts

  import Medcerter.AccountsFixtures
  alias Medcerter.Accounts.{Doctor, DoctorToken}

  describe "get_doctor_by_email/1" do
    test "does not return the doctor if the email does not exist" do
      refute Accounts.get_doctor_by_email("unknown@example.com")
    end

    test "returns the doctor if the email exists" do
      %{id: id} = doctor = doctor_fixture()
      assert %Doctor{id: ^id} = Accounts.get_doctor_by_email(doctor.email)
    end
  end

  describe "get_doctor_by_email_and_password/2" do
    test "does not return the doctor if the email does not exist" do
      refute Accounts.get_doctor_by_email_and_password("unknown@example.com", "hello world!")
    end

    test "does not return the doctor if the password is not valid" do
      doctor = doctor_fixture()
      refute Accounts.get_doctor_by_email_and_password(doctor.email, "invalid")
    end

    test "returns the doctor if the email and password are valid" do
      %{id: id} = doctor = doctor_fixture()

      assert %Doctor{id: ^id} =
               Accounts.get_doctor_by_email_and_password(doctor.email, valid_doctor_password())
    end
  end

  describe "get_doctor!/1" do
    test "raises if id is invalid" do
      assert_raise Ecto.NoResultsError, fn ->
        Accounts.get_doctor!("11111111-1111-1111-1111-111111111111")
      end
    end

    test "returns the doctor with the given id" do
      %{id: id} = doctor = doctor_fixture()
      assert %Doctor{id: ^id} = Accounts.get_doctor!(doctor.id)
    end
  end

  describe "register_doctor/1" do
    test "requires email and password to be set" do
      {:error, changeset} = Accounts.register_doctor(%{})

      assert %{
               password: ["can't be blank"],
               email: ["can't be blank"],
               first_name: ["can't be blank"],
               last_name: ["can't be blank"]
             } = errors_on(changeset)
    end

    test "validates email and password when given" do
      {:error, changeset} = Accounts.register_doctor(%{email: "not valid", password: "not valid"})

      assert %{
               email: ["must have the @ sign and no spaces"],
               password: ["should be at least 12 character(s)"]
             } = errors_on(changeset)
    end

    test "validates maximum values for email and password for security" do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.register_doctor(%{email: too_long, password: too_long})
      assert "should be at most 160 character(s)" in errors_on(changeset).email
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates email uniqueness" do
      %{email: email} = doctor_fixture()
      {:error, changeset} = Accounts.register_doctor(%{email: email})
      assert "has already been taken" in errors_on(changeset).email

      # Now try with the upper cased email too, to check that email case is ignored.
      {:error, changeset} = Accounts.register_doctor(%{email: String.upcase(email)})
      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates sex inclusion" do
      invalid_sex = valid_doctor_attributes(%{sex: :x})
      {:error, changeset} = Accounts.register_doctor(invalid_sex)
      assert "is invalid" in errors_on(changeset).sex
    end

    test "registers doctors with a hashed password" do
      email = unique_doctor_email()
      {:ok, doctor} = Accounts.register_doctor(valid_doctor_attributes(email: email))
      assert doctor.email == email
      assert is_binary(doctor.hashed_password)
      assert is_nil(doctor.confirmed_at)
      assert is_nil(doctor.password)
    end
  end

  describe "change_doctor_registration/2" do
    test "returns a changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_doctor_registration(%Doctor{})
      assert changeset.required == [:password, :email, :first_name, :last_name]
    end

    test "allows fields to be set" do
      email = unique_doctor_email()
      password = valid_doctor_password()

      changeset =
        Accounts.change_doctor_registration(
          %Doctor{},
          valid_doctor_attributes(email: email, password: password)
        )

      assert changeset.valid?
      assert get_change(changeset, :email) == email
      assert get_change(changeset, :password) == password
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "change_doctor_email/2" do
    test "returns a doctor changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_doctor_email(%Doctor{})
      assert changeset.required == [:email]
    end
  end

  describe "apply_doctor_email/3" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "requires email to change", %{doctor: doctor} do
      {:error, changeset} = Accounts.apply_doctor_email(doctor, valid_doctor_password(), %{})
      assert %{email: ["did not change"]} = errors_on(changeset)
    end

    test "validates email", %{doctor: doctor} do
      {:error, changeset} =
        Accounts.apply_doctor_email(doctor, valid_doctor_password(), %{email: "not valid"})

      assert %{email: ["must have the @ sign and no spaces"]} = errors_on(changeset)
    end

    test "validates maximum value for email for security", %{doctor: doctor} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.apply_doctor_email(doctor, valid_doctor_password(), %{email: too_long})

      assert "should be at most 160 character(s)" in errors_on(changeset).email
    end

    test "validates email uniqueness", %{doctor: doctor} do
      %{email: email} = doctor_fixture()

      {:error, changeset} =
        Accounts.apply_doctor_email(doctor, valid_doctor_password(), %{email: email})

      assert "has already been taken" in errors_on(changeset).email
    end

    test "validates current password", %{doctor: doctor} do
      {:error, changeset} =
        Accounts.apply_doctor_email(doctor, "invalid", %{email: unique_doctor_email()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "applies the email without persisting it", %{doctor: doctor} do
      email = unique_doctor_email()

      {:ok, doctor} =
        Accounts.apply_doctor_email(doctor, valid_doctor_password(), %{email: email})

      assert doctor.email == email
      assert Accounts.get_doctor!(doctor.id).email != email
    end
  end

  describe "deliver_update_email_instructions/3" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "sends token through notification", %{doctor: doctor} do
      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_update_email_instructions(doctor, "current@example.com", url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert doctor_token = Repo.get_by(DoctorToken, token: :crypto.hash(:sha256, token))
      assert doctor_token.doctor_id == doctor.id
      assert doctor_token.sent_to == doctor.email
      assert doctor_token.context == "change:current@example.com"
    end
  end

  describe "update_doctor_email/2" do
    setup do
      doctor = doctor_fixture()
      email = unique_doctor_email()

      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_update_email_instructions(%{doctor | email: email}, doctor.email, url)
        end)

      %{doctor: doctor, token: token, email: email}
    end

    test "updates the email with a valid token", %{doctor: doctor, token: token, email: email} do
      assert Accounts.update_doctor_email(doctor, token) == :ok
      changed_doctor = Repo.get!(Doctor, doctor.id)
      assert changed_doctor.email != doctor.email
      assert changed_doctor.email == email
      assert changed_doctor.confirmed_at
      assert changed_doctor.confirmed_at != doctor.confirmed_at
      refute Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end

    test "does not update email with invalid token", %{doctor: doctor} do
      assert Accounts.update_doctor_email(doctor, "oops") == :error
      assert Repo.get!(Doctor, doctor.id).email == doctor.email
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end

    test "does not update email if doctor email changed", %{doctor: doctor, token: token} do
      assert Accounts.update_doctor_email(%{doctor | email: "current@example.com"}, token) ==
               :error

      assert Repo.get!(Doctor, doctor.id).email == doctor.email
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end

    test "does not update email if token expired", %{doctor: doctor, token: token} do
      {1, nil} = Repo.update_all(DoctorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.update_doctor_email(doctor, token) == :error
      assert Repo.get!(Doctor, doctor.id).email == doctor.email
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end
  end

  describe "change_doctor_password/2" do
    test "returns a doctor changeset" do
      assert %Ecto.Changeset{} = changeset = Accounts.change_doctor_password(%Doctor{})
      assert changeset.required == [:password]
    end

    test "allows fields to be set" do
      changeset =
        Accounts.change_doctor_password(%Doctor{}, %{
          "password" => "new valid password"
        })

      assert changeset.valid?
      assert get_change(changeset, :password) == "new valid password"
      assert is_nil(get_change(changeset, :hashed_password))
    end
  end

  describe "update_doctor_password/3" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "validates password", %{doctor: doctor} do
      {:error, changeset} =
        Accounts.update_doctor_password(doctor, valid_doctor_password(), %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{doctor: doctor} do
      too_long = String.duplicate("db", 100)

      {:error, changeset} =
        Accounts.update_doctor_password(doctor, valid_doctor_password(), %{password: too_long})

      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "validates current password", %{doctor: doctor} do
      {:error, changeset} =
        Accounts.update_doctor_password(doctor, "invalid", %{password: valid_doctor_password()})

      assert %{current_password: ["is not valid"]} = errors_on(changeset)
    end

    test "updates the password", %{doctor: doctor} do
      {:ok, doctor} =
        Accounts.update_doctor_password(doctor, valid_doctor_password(), %{
          password: "new valid password"
        })

      assert is_nil(doctor.password)
      assert Accounts.get_doctor_by_email_and_password(doctor.email, "new valid password")
    end

    test "deletes all tokens for the given doctor", %{doctor: doctor} do
      _ = Accounts.generate_doctor_session_token(doctor)

      {:ok, _} =
        Accounts.update_doctor_password(doctor, valid_doctor_password(), %{
          password: "new valid password"
        })

      refute Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end
  end

  describe "generate_doctor_session_token/1" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "generates a token", %{doctor: doctor} do
      token = Accounts.generate_doctor_session_token(doctor)
      assert doctor_token = Repo.get_by(DoctorToken, token: token)
      assert doctor_token.context == "session"

      # Creating the same token for another doctor should fail
      assert_raise Ecto.ConstraintError, fn ->
        Repo.insert!(%DoctorToken{
          token: doctor_token.token,
          doctor_id: doctor_fixture().id,
          context: "session"
        })
      end
    end
  end

  describe "get_doctor_by_session_token/1" do
    setup do
      doctor = doctor_fixture()
      token = Accounts.generate_doctor_session_token(doctor)
      %{doctor: doctor, token: token}
    end

    test "returns doctor by token", %{doctor: doctor, token: token} do
      assert session_doctor = Accounts.get_doctor_by_session_token(token)
      assert session_doctor.id == doctor.id
    end

    test "does not return doctor for invalid token" do
      refute Accounts.get_doctor_by_session_token("oops")
    end

    test "does not return doctor for expired token", %{token: token} do
      {1, nil} = Repo.update_all(DoctorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_doctor_by_session_token(token)
    end
  end

  describe "delete_session_token/1" do
    test "deletes the token" do
      doctor = doctor_fixture()
      token = Accounts.generate_doctor_session_token(doctor)
      assert Accounts.delete_session_token(token) == :ok
      refute Accounts.get_doctor_by_session_token(token)
    end
  end

  describe "deliver_doctor_confirmation_instructions/2" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "sends token through notification", %{doctor: doctor} do
      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_confirmation_instructions(doctor, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert doctor_token = Repo.get_by(DoctorToken, token: :crypto.hash(:sha256, token))
      assert doctor_token.doctor_id == doctor.id
      assert doctor_token.sent_to == doctor.email
      assert doctor_token.context == "confirm"
    end
  end

  describe "confirm_doctor/1" do
    setup do
      doctor = doctor_fixture()

      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_confirmation_instructions(doctor, url)
        end)

      %{doctor: doctor, token: token}
    end

    test "confirms the email with a valid token", %{doctor: doctor, token: token} do
      assert {:ok, confirmed_doctor} = Accounts.confirm_doctor(token)
      assert confirmed_doctor.confirmed_at
      assert confirmed_doctor.confirmed_at != doctor.confirmed_at
      assert Repo.get!(Doctor, doctor.id).confirmed_at
      refute Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end

    test "does not confirm with invalid token", %{doctor: doctor} do
      assert Accounts.confirm_doctor("oops") == :error
      refute Repo.get!(Doctor, doctor.id).confirmed_at
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end

    test "does not confirm email if token expired", %{doctor: doctor, token: token} do
      {1, nil} = Repo.update_all(DoctorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      assert Accounts.confirm_doctor(token) == :error
      refute Repo.get!(Doctor, doctor.id).confirmed_at
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end
  end

  describe "deliver_doctor_reset_password_instructions/2" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "sends token through notification", %{doctor: doctor} do
      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_reset_password_instructions(doctor, url)
        end)

      {:ok, token} = Base.url_decode64(token, padding: false)
      assert doctor_token = Repo.get_by(DoctorToken, token: :crypto.hash(:sha256, token))
      assert doctor_token.doctor_id == doctor.id
      assert doctor_token.sent_to == doctor.email
      assert doctor_token.context == "reset_password"
    end
  end

  describe "get_doctor_by_reset_password_token/1" do
    setup do
      doctor = doctor_fixture()

      token =
        extract_doctor_token(fn url ->
          Accounts.deliver_doctor_reset_password_instructions(doctor, url)
        end)

      %{doctor: doctor, token: token}
    end

    test "returns the doctor with valid token", %{doctor: %{id: id}, token: token} do
      assert %Doctor{id: ^id} = Accounts.get_doctor_by_reset_password_token(token)
      assert Repo.get_by(DoctorToken, doctor_id: id)
    end

    test "does not return the doctor with invalid token", %{doctor: doctor} do
      refute Accounts.get_doctor_by_reset_password_token("oops")
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end

    test "does not return the doctor if token expired", %{doctor: doctor, token: token} do
      {1, nil} = Repo.update_all(DoctorToken, set: [inserted_at: ~N[2020-01-01 00:00:00]])
      refute Accounts.get_doctor_by_reset_password_token(token)
      assert Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end
  end

  describe "reset_doctor_password/2" do
    setup do
      %{doctor: doctor_fixture()}
    end

    test "validates password", %{doctor: doctor} do
      {:error, changeset} =
        Accounts.reset_doctor_password(doctor, %{
          password: "not valid",
          password_confirmation: "another"
        })

      assert %{
               password: ["should be at least 12 character(s)"],
               password_confirmation: ["does not match password"]
             } = errors_on(changeset)
    end

    test "validates maximum values for password for security", %{doctor: doctor} do
      too_long = String.duplicate("db", 100)
      {:error, changeset} = Accounts.reset_doctor_password(doctor, %{password: too_long})
      assert "should be at most 72 character(s)" in errors_on(changeset).password
    end

    test "updates the password", %{doctor: doctor} do
      {:ok, updated_doctor} =
        Accounts.reset_doctor_password(doctor, %{password: "new valid password"})

      assert is_nil(updated_doctor.password)
      assert Accounts.get_doctor_by_email_and_password(doctor.email, "new valid password")
    end

    test "deletes all tokens for the given doctor", %{doctor: doctor} do
      _ = Accounts.generate_doctor_session_token(doctor)
      {:ok, _} = Accounts.reset_doctor_password(doctor, %{password: "new valid password"})
      refute Repo.get_by(DoctorToken, doctor_id: doctor.id)
    end
  end

  describe "inspect/2" do
    test "does not include password" do
      refute inspect(%Doctor{password: "123456"}) =~ "password: \"123456\""
    end
  end
end
