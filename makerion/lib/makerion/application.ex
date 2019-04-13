defmodule Makerion.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  alias Makerion.{PrinterPoller, Repo}

  def start(_type, _args) do
    printer_driver = printer_driver()
    printer_config = printer_driver_config(printer_driver)
    children = [
      Repo,

      # Printer driver to use
      printer_driver.child_spec([printer_config]),

      PrinterPoller.child_spec([printer_source: printer_config]),

      # Printer Events PubSub
      {Registry, keys: :duplicate, name: Registry.PrinterEvents, id: Registry.PrinterEvents}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Makerion.Supervisor)
  end

  defp printer_driver do
    Application.get_env(:makerion, :printer_driver)
  end

  defp printer_driver_config(driver) do
    case driver do
      Moddity.FakeDriver -> %Moddity.FakeDriver{}
      Moddity.Driver -> %Moddity.Driver{}
    end
  end
end
