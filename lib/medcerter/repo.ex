defmodule Medcerter.Repo do
  use Ecto.Repo,
    otp_app: :medcerter,
    adapter: Ecto.Adapters.Postgres
end
