defmodule Peridot.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the Ecto repository
      Peridot.Repo,
      # Start the endpoint when the application starts
      PeridotWeb.Endpoint,
      %{  id: Peridot.Postfinder, start: {Peridot.Postfinder, :start_link, []}},
      %{  id: Peridot.Jobfinder, start: {Peridot.Jobfinder, :start_link, []}}
      # Starts a worker by calling: Peridot.Worker.start_link(arg)
      # {Peridot.Worker, arg},
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Peridot.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    PeridotWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
