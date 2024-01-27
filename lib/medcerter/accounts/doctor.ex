defmodule Medcerter.Accounts.Doctor do
  use Ecto.Schema
  import Ecto.Changeset

  alias Medcerter.Visits.Visit
  alias Medcerter.Patients.DoctorPatient
  alias Medcerter.Prescriptions.Prescription
  alias Medcerter.Accounts.ContactInformation

  @primary_key {:id, :binary_id, autogenerate: true}
  @foreign_key_type :binary_id
  schema "doctors" do
    field :email, :string
    field :first_name, :string
    field :middle_name, :string
    field :last_name, :string
    field :sex, Ecto.Enum, values: [:m, :f]
    field :password, :string, virtual: true, redact: true
    field :password_confirmation, :string, virtual: true, redact: true
    field :hashed_password, :string, redact: true
    field :confirmed_at, :naive_datetime
    field :document_header, :string
    field :license_no, :string
    field :ptr_no, :string
    field :s2_no, :string
    embeds_many :contact_information, ContactInformation
    has_many :doctor_patients, DoctorPatient
    has_many :patients, through: [:doctor_patients, :patient]
    has_many :visits, Visit
    has_many :prescriptions, Prescription

    timestamps()
  end

  @doc """
  A doctor changeset for registration.

  It is important to validate the length of both email and password.
  Otherwise databases may truncate the email without warnings, which
  could lead to unpredictable or insecure behaviour. Long passwords may
  also be very expensive to hash for certain algorithms.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def registration_changeset(doctor, attrs, opts \\ []) do
    doctor
    |> cast(attrs, [
      :email, 
      :password, 
      :password_confirmation,
      :first_name, 
      :last_name, 
      :middle_name, 
      :sex, 
      :document_header,
      :license_no,
      :ptr_no,
      :s2_no
    ])
    |> validate_required([
      :first_name, 
      :last_name,
      :document_header,
      :license_no
    ])
    |> cast_embed(:contact_information, required: true)
    |> validate_inclusion(:sex, [:m, :f])
    |> validate_email()
    |> validate_password(opts)
  end

  defp validate_email(changeset) do
    changeset
    |> validate_required([:email])
    |> validate_format(:email, ~r/^[^\s]+@[^\s]+$/, message: "must have the @ sign and no spaces")
    |> validate_length(:email, max: 160)
    |> unsafe_validate_unique(:email, Medcerter.Repo)
    |> unique_constraint(:email)
  end

  defp validate_password(changeset, opts) do
    changeset
    |> validate_required([:password])
    |> validate_length(:password, min: 12, max: 72)
    # |> validate_format(:password, ~r/[a-z]/, message: "at least one lower case character")
    # |> validate_format(:password, ~r/[A-Z]/, message: "at least one upper case character")
    # |> validate_format(:password, ~r/[!?@#$%^&*_0-9]/, message: "at least one digit or punctuation character")
    |> validate_confirmation(:password, required: true)
    |> maybe_hash_password(opts)
  end

  defp maybe_hash_password(changeset, opts) do
    hash_password? = Keyword.get(opts, :hash_password, true)
    password = get_change(changeset, :password)

    if hash_password? && password && changeset.valid? do
      changeset
      # If using Bcrypt, then further validate it is at most 72 bytes long
      |> validate_length(:password, max: 72, count: :bytes)
      |> put_change(:hashed_password, Bcrypt.hash_pwd_salt(password))
      |> delete_change(:password)
    else
      changeset
    end
  end

  @doc """
  A doctor changeset for changing the email.

  It requires the email to change otherwise an error is added.
  """
  def email_changeset(doctor, attrs) do
    doctor
    |> cast(attrs, [:email])
    |> validate_email()
    |> case do
      %{changes: %{email: _}} = changeset -> changeset
      %{} = changeset -> add_error(changeset, :email, "did not change")
    end
  end

  @doc """
  A doctor changeset for changing the password.

  ## Options

    * `:hash_password` - Hashes the password so it can be stored securely
      in the database and ensures the password field is cleared to prevent
      leaks in the logs. If password hashing is not needed and clearing the
      password field is not desired (like when using this changeset for
      validations on a LiveView form), this option can be set to `false`.
      Defaults to `true`.
  """
  def password_changeset(doctor, attrs, opts \\ []) do
    doctor
    |> cast(attrs, [:password])
    |> validate_confirmation(:password, message: "does not match password")
    |> validate_password(opts)
  end

  @doc """
  Confirms the account by setting `confirmed_at`.
  """
  def confirm_changeset(doctor) do
    now = NaiveDateTime.utc_now() |> NaiveDateTime.truncate(:second)
    change(doctor, confirmed_at: now)
  end

  @doc """
  Verifies the password.

  If there is no doctor or the doctor doesn't have a password, we call
  `Bcrypt.no_user_verify/0` to avoid timing attacks.
  """
  def valid_password?(%Medcerter.Accounts.Doctor{hashed_password: hashed_password}, password)
      when is_binary(hashed_password) and byte_size(password) > 0 do
    Bcrypt.verify_pass(password, hashed_password)
  end

  def valid_password?(_, _) do
    Bcrypt.no_user_verify()
    false
  end

  @doc """
  Validates the current password otherwise adds an error to the changeset.
  """
  def validate_current_password(changeset, password) do
    if valid_password?(changeset.data, password) do
      changeset
    else
      add_error(changeset, :current_password, "is not valid")
    end
  end
end
