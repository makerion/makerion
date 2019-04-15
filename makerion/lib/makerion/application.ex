defmodule Makerion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Makerion.{PrinterPoller, Repo}
  alias Moddity.Backend.{PythonShell, Simulator}
  alias Moddity.Driver

  def start(_type, _args) do
    printer_backend = printer_backend()
    children = maybe_simulator(printer_backend) ++ [
      Repo,
      Driver.child_spec(backend: printer_backend),
      PrinterPoller.child_spec([printer_source: %Driver{}]),
      # Printer Events PubSub
      {Registry, keys: :duplicate, name: Registry.PrinterEvents, id: Registry.PrinterEvents}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Makerion.Supervisor)
  end

  defp printer_backend do
    Application.get_env(:makerion, :printer_backend, PythonShell)
  end

  defp maybe_simulator(Simulator), do: [Simulator]
  defp maybe_simulator(_), do: []
end
