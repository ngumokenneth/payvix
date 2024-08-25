defmodule Payvix.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      PayvixWeb.Telemetry,
      Payvix.Repo,
      {DNSCluster, query: Application.get_env(:payvix, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Payvix.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Payvix.Finch},
      # Start a worker by calling: Payvix.Worker.start_link(arg)
      # {Payvix.Worker, arg},
      # Start to serve requests, typically the last entry
      PayvixWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Payvix.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    PayvixWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
