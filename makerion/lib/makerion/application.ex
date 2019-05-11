defmodule Makerion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Makerion.Repo
  alias Moddity.Backend.{Libusb, PythonShell, Simulator}
  alias Moddity.Driver

  def start(_type, _args) do
    printer_backend = printer_backend()
    children = maybe_backend(printer_backend) ++ [
      Repo,
      Driver.child_spec(backend: printer_backend),
      # Print Context Events PubSub
      {Registry, keys: :duplicate, name: Registry.MakerionPrintEvents, id: Registry.MakerionPrintEvents}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Makerion.Supervisor)
  end

  defp printer_backend do
    Application.get_env(:makerion, :printer_backend, Libusb)
  end

  defp maybe_backend(Simulator), do: [Simulator]
  defp maybe_backend(Libusb), do: [Libusb]
  defp maybe_backend(_), do: []
end
