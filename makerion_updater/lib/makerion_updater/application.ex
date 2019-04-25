defmodule MakerionUpdater.Application do
  @moduledoc false

  use Application

  alias MakerionUpdater.FirmwareManager

  def start(_type, _args) do
    children = [
      FirmwareManager,
      # Firmware Events PubSub
      {Registry, keys: :duplicate, name: Registry.MakerionFirmwareEvents, id: Registry.MakerionFirmwareEvents}
    ]

    opts = [strategy: :one_for_one, name: MakerionUpdater.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
