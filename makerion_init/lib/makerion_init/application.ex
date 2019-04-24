defmodule MakerionInit.Application do
  @moduledoc false

  use Application

  alias MakerionInit.{Options, NetworkManager}

  def start(_type, _args) do
    opts = Options.get()

    children = [
      {NetworkManager, opts}
    ]

    opts = [strategy: :one_for_one, name: MakerionInit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
