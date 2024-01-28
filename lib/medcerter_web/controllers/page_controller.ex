defmodule MedcerterWeb.PageController do
  use MedcerterWeb, :controller

  def index(conn, _params) do
    conn
    |> redirect(to: Routes.doctor_session_path(conn, :new))
    |> halt()
  end
end
