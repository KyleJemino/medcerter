defmodule Medcerter.AccountsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Medcerter.Accounts` context.
  """

  def unique_doctor_email, do: "doctor#{System.unique_integer()}@example.com"
  def valid_doctor_password, do: "hello world!"

  def valid_doctor_attributes(attrs \\ %{}) do
    Enum.into(attrs, %{
      email: unique_doctor_email(),
      password: valid_doctor_password(),
      first_name: "First",
      middle_name: "Mid",
      last_name: "Last",
      sex: :m
    })
  end

  def doctor_fixture(attrs \\ %{}) do
    {:ok, doctor} =
      attrs
      |> valid_doctor_attributes()
      |> Medcerter.Accounts.register_doctor()

    doctor
  end

  def extract_doctor_token(fun) do
    {:ok, captured_email} = fun.(&"[TOKEN]#{&1}[TOKEN]")
    [_, token | _] = String.split(captured_email.text_body, "[TOKEN]")
    token
  end
end
