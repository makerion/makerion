defmodule MakerionWeb.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias MakerionWeb.PrinterEventHandler

  def start(_type, _args) do
    # List all child processes to be supervised
    children = [
      # Start the endpoint when the application starts
      MakerionWeb.Endpoint,
      # Starts a worker by calling: MakerionWeb.Worker.start_link(arg)
      # {MakerionWeb.Worker, arg},
      {PrinterEventHandler, name: PrinterEventHandler}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: MakerionWeb.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  def config_change(changed, _new, removed) do
    MakerionWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
