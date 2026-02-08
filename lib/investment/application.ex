defmodule Investment.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      InvestmentWeb.Telemetry,
      Investment.Repo,
      {DNSCluster, query: Application.get_env(:investment, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Investment.PubSub},
      # Start a worker by calling: Investment.Worker.start_link(arg)
      # {Investment.Worker, arg},
      # Start to serve requests, typically the last entry
      InvestmentWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Investment.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    InvestmentWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
