defmodule MedcerterWeb.ConnCase do
  @moduledoc """
  This module defines the test case to be used by
  tests that require setting up a connection.

  Such tests rely on `Phoenix.ConnTest` and also
  import other functionality to make it easier
  to build common data structures and query the data layer.

  Finally, if the test case interacts with the database,
  we enable the SQL sandbox, so changes done to the database
  are reverted at the end of every test. If you are using
  PostgreSQL, you can even run database tests asynchronously
  by setting `use MedcerterWeb.ConnCase, async: true`, although
  this option is not recommended for other databases.
  """

  use ExUnit.CaseTemplate

  using do
    quote do
      # Import conveniences for testing with connections
      import Plug.Conn
      import Phoenix.ConnTest
      import MedcerterWeb.ConnCase

      alias MedcerterWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      @endpoint MedcerterWeb.Endpoint
    end
  end

  setup tags do
    Medcerter.DataCase.setup_sandbox(tags)
    {:ok, conn: Phoenix.ConnTest.build_conn()}
  end

  @doc """
  Setup helper that registers and logs in doctors.

      setup :register_and_log_in_doctor

  It stores an updated connection and a registered doctor in the
  test context.
  """
  def register_and_log_in_doctor(%{conn: conn}) do
    doctor = Medcerter.AccountsFixtures.doctor_fixture()
    %{conn: log_in_doctor(conn, doctor), doctor: doctor}
  end

  @doc """
  Logs the given `doctor` into the `conn`.

  It returns an updated `conn`.
  """
  def log_in_doctor(conn, doctor) do
    token = Medcerter.Accounts.generate_doctor_session_token(doctor)

    conn
    |> Phoenix.ConnTest.init_test_session(%{})
    |> Plug.Conn.put_session(:doctor_token, token)
  end
end
