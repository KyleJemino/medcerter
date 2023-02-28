defmodule Medcerter.Accounts do
  @moduledoc """
  The Accounts context.
  """

  import Ecto.Query, warn: false
  alias Medcerter.Repo

  alias Medcerter.Accounts.{Doctor, DoctorToken, DoctorNotifier}

  ## Database getters

  @doc """
  Gets a doctor by email.

  ## Examples

      iex> get_doctor_by_email("foo@example.com")
      %Doctor{}

      iex> get_doctor_by_email("unknown@example.com")
      nil

  """
  def get_doctor_by_email(email) when is_binary(email) do
    Repo.get_by(Doctor, email: email)
  end

  @doc """
  Gets a doctor by email and password.

  ## Examples

      iex> get_doctor_by_email_and_password("foo@example.com", "correct_password")
      %Doctor{}

      iex> get_doctor_by_email_and_password("foo@example.com", "invalid_password")
      nil

  """
  def get_doctor_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    doctor = Repo.get_by(Doctor, email: email)
    if Doctor.valid_password?(doctor, password), do: doctor
  end

  @doc """
  Gets a single doctor.

  Raises `Ecto.NoResultsError` if the Doctor does not exist.

  ## Examples

      iex> get_doctor!(123)
      %Doctor{}

      iex> get_doctor!(456)
      ** (Ecto.NoResultsError)

  """
  def get_doctor!(id), do: Repo.get!(Doctor, id)

  ## Doctor registration

  @doc """
  Registers a doctor.

  ## Examples

      iex> register_doctor(%{field: value})
      {:ok, %Doctor{}}

      iex> register_doctor(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def register_doctor(attrs) do
    %Doctor{}
    |> Doctor.registration_changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking doctor changes.

  ## Examples

      iex> change_doctor_registration(doctor)
      %Ecto.Changeset{data: %Doctor{}}

  """
  def change_doctor_registration(%Doctor{} = doctor, attrs \\ %{}) do
    Doctor.registration_changeset(doctor, attrs, hash_password: false)
  end

  ## Settings

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the doctor email.

  ## Examples

      iex> change_doctor_email(doctor)
      %Ecto.Changeset{data: %Doctor{}}

  """
  def change_doctor_email(doctor, attrs \\ %{}) do
    Doctor.email_changeset(doctor, attrs)
  end

  @doc """
  Emulates that the email will change without actually changing
  it in the database.

  ## Examples

      iex> apply_doctor_email(doctor, "valid password", %{email: ...})
      {:ok, %Doctor{}}

      iex> apply_doctor_email(doctor, "invalid password", %{email: ...})
      {:error, %Ecto.Changeset{}}

  """
  def apply_doctor_email(doctor, password, attrs) do
    doctor
    |> Doctor.email_changeset(attrs)
    |> Doctor.validate_current_password(password)
    |> Ecto.Changeset.apply_action(:update)
  end

  @doc """
  Updates the doctor email using the given token.

  If the token matches, the doctor email is updated and the token is deleted.
  The confirmed_at date is also updated to the current time.
  """
  def update_doctor_email(doctor, token) do
    context = "change:#{doctor.email}"

    with {:ok, query} <- DoctorToken.verify_change_email_token_query(token, context),
         %DoctorToken{sent_to: email} <- Repo.one(query),
         {:ok, _} <- Repo.transaction(doctor_email_multi(doctor, email, context)) do
      :ok
    else
      _ -> :error
    end
  end

  defp doctor_email_multi(doctor, email, context) do
    changeset =
      doctor
      |> Doctor.email_changeset(%{email: email})
      |> Doctor.confirm_changeset()

    Ecto.Multi.new()
    |> Ecto.Multi.update(:doctor, changeset)
    |> Ecto.Multi.delete_all(:tokens, DoctorToken.doctor_and_contexts_query(doctor, [context]))
  end

  @doc """
  Delivers the update email instructions to the given doctor.

  ## Examples

      iex> deliver_update_email_instructions(doctor, current_email, &Routes.doctor_update_email_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_update_email_instructions(%Doctor{} = doctor, current_email, update_email_url_fun)
      when is_function(update_email_url_fun, 1) do
    {encoded_token, doctor_token} =
      DoctorToken.build_email_token(doctor, "change:#{current_email}")

    Repo.insert!(doctor_token)
    DoctorNotifier.deliver_update_email_instructions(doctor, update_email_url_fun.(encoded_token))
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for changing the doctor password.

  ## Examples

      iex> change_doctor_password(doctor)
      %Ecto.Changeset{data: %Doctor{}}

  """
  def change_doctor_password(doctor, attrs \\ %{}) do
    Doctor.password_changeset(doctor, attrs, hash_password: false)
  end

  @doc """
  Updates the doctor password.

  ## Examples

      iex> update_doctor_password(doctor, "valid password", %{password: ...})
      {:ok, %Doctor{}}

      iex> update_doctor_password(doctor, "invalid password", %{password: ...})
      {:error, %Ecto.Changeset{}}

  """
  def update_doctor_password(doctor, password, attrs) do
    changeset =
      doctor
      |> Doctor.password_changeset(attrs)
      |> Doctor.validate_current_password(password)

    Ecto.Multi.new()
    |> Ecto.Multi.update(:doctor, changeset)
    |> Ecto.Multi.delete_all(:tokens, DoctorToken.doctor_and_contexts_query(doctor, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{doctor: doctor}} -> {:ok, doctor}
      {:error, :doctor, changeset, _} -> {:error, changeset}
    end
  end

  ## Session

  @doc """
  Generates a session token.
  """
  def generate_doctor_session_token(doctor) do
    {token, doctor_token} = DoctorToken.build_session_token(doctor)
    Repo.insert!(doctor_token)
    token
  end

  @doc """
  Gets the doctor with the given signed token.
  """
  def get_doctor_by_session_token(token) do
    {:ok, query} = DoctorToken.verify_session_token_query(token)
    Repo.one(query)
  end

  @doc """
  Deletes the signed token with the given context.
  """
  def delete_session_token(token) do
    Repo.delete_all(DoctorToken.token_and_context_query(token, "session"))
    :ok
  end

  ## Confirmation

  @doc """
  Delivers the confirmation email instructions to the given doctor.

  ## Examples

      iex> deliver_doctor_confirmation_instructions(doctor, &Routes.doctor_confirmation_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

      iex> deliver_doctor_confirmation_instructions(confirmed_doctor, &Routes.doctor_confirmation_url(conn, :edit, &1))
      {:error, :already_confirmed}

  """
  def deliver_doctor_confirmation_instructions(%Doctor{} = doctor, confirmation_url_fun)
      when is_function(confirmation_url_fun, 1) do
    if doctor.confirmed_at do
      {:error, :already_confirmed}
    else
      {encoded_token, doctor_token} = DoctorToken.build_email_token(doctor, "confirm")
      Repo.insert!(doctor_token)

      DoctorNotifier.deliver_confirmation_instructions(
        doctor,
        confirmation_url_fun.(encoded_token)
      )
    end
  end

  @doc """
  Confirms a doctor by the given token.

  If the token matches, the doctor account is marked as confirmed
  and the token is deleted.
  """
  def confirm_doctor(token) do
    with {:ok, query} <- DoctorToken.verify_email_token_query(token, "confirm"),
         %Doctor{} = doctor <- Repo.one(query),
         {:ok, %{doctor: doctor}} <- Repo.transaction(confirm_doctor_multi(doctor)) do
      {:ok, doctor}
    else
      _ -> :error
    end
  end

  defp confirm_doctor_multi(doctor) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:doctor, Doctor.confirm_changeset(doctor))
    |> Ecto.Multi.delete_all(:tokens, DoctorToken.doctor_and_contexts_query(doctor, ["confirm"]))
  end

  ## Reset password

  @doc """
  Delivers the reset password email to the given doctor.

  ## Examples

      iex> deliver_doctor_reset_password_instructions(doctor, &Routes.doctor_reset_password_url(conn, :edit, &1))
      {:ok, %{to: ..., body: ...}}

  """
  def deliver_doctor_reset_password_instructions(%Doctor{} = doctor, reset_password_url_fun)
      when is_function(reset_password_url_fun, 1) do
    {encoded_token, doctor_token} = DoctorToken.build_email_token(doctor, "reset_password")
    Repo.insert!(doctor_token)

    DoctorNotifier.deliver_reset_password_instructions(
      doctor,
      reset_password_url_fun.(encoded_token)
    )
  end

  @doc """
  Gets the doctor by reset password token.

  ## Examples

      iex> get_doctor_by_reset_password_token("validtoken")
      %Doctor{}

      iex> get_doctor_by_reset_password_token("invalidtoken")
      nil

  """
  def get_doctor_by_reset_password_token(token) do
    with {:ok, query} <- DoctorToken.verify_email_token_query(token, "reset_password"),
         %Doctor{} = doctor <- Repo.one(query) do
      doctor
    else
      _ -> nil
    end
  end

  @doc """
  Resets the doctor password.

  ## Examples

      iex> reset_doctor_password(doctor, %{password: "new long password", password_confirmation: "new long password"})
      {:ok, %Doctor{}}

      iex> reset_doctor_password(doctor, %{password: "valid", password_confirmation: "not the same"})
      {:error, %Ecto.Changeset{}}

  """
  def reset_doctor_password(doctor, attrs) do
    Ecto.Multi.new()
    |> Ecto.Multi.update(:doctor, Doctor.password_changeset(doctor, attrs))
    |> Ecto.Multi.delete_all(:tokens, DoctorToken.doctor_and_contexts_query(doctor, :all))
    |> Repo.transaction()
    |> case do
      {:ok, %{doctor: doctor}} -> {:ok, doctor}
      {:error, :doctor, changeset, _} -> {:error, changeset}
    end
  end
end
