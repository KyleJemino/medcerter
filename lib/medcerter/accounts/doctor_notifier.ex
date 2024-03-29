defmodule Medcerter.Accounts.DoctorNotifier do
  import Swoosh.Email

  alias Medcerter.Mailer

  # Delivers the email using the application mailer.
  defp deliver(recipient, subject, body) do
    email =
      new()
      |> to(recipient)
      |> from({"Medcerter", "contact@example.com"})
      |> subject(subject)
      |> text_body(body)

    with {:ok, _metadata} <- Mailer.deliver(email) do
      {:ok, email}
    end
  end

  @doc """
  Deliver instructions to confirm account.
  """
  def deliver_confirmation_instructions(doctor, url) do
    deliver(doctor.email, "Confirmation instructions", """

    ==============================

    Hi #{doctor.email},

    You can confirm your account by visiting the URL below:

    #{url}

    If you didn't create an account with us, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to reset a doctor password.
  """
  def deliver_reset_password_instructions(doctor, url) do
    deliver(doctor.email, "Reset password instructions", """

    ==============================

    Hi #{doctor.email},

    You can reset your password by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end

  @doc """
  Deliver instructions to update a doctor email.
  """
  def deliver_update_email_instructions(doctor, url) do
    deliver(doctor.email, "Update email instructions", """

    ==============================

    Hi #{doctor.email},

    You can change your email by visiting the URL below:

    #{url}

    If you didn't request this change, please ignore this.

    ==============================
    """)
  end
end
