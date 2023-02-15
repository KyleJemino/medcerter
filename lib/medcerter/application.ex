defmodule Medcerter.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Ecto repository
      Medcerter.Repo,
      # Start the Telemetry supervisor
      MedcerterWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: Medcerter.PubSub},
      # Start the Endpoint (http/https)
      MedcerterWeb.Endpoint
      # Start a worker by calling: Medcerter.Worker.start_link(arg)
      # {Medcerter.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Medcerter.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MedcerterWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
