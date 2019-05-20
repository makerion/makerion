defmodule MakerionInit.Application do
  @moduledoc false

  use Application

  alias MakerionInit.{Options, NetworkManager, SSHConsole}

  def start(_type, _args) do
    opts = Options.get()

    children = [{NetworkManager, opts}]
    children = case Map.get(opts, :ssh_authorized_keys) do
                 nil -> children
                 authorized_keys ->
                   # Update firmware ssh config as well - TODO this is hacky
                   Application.put_env(:nerves_firmware_ssh, :authorized_keys, authorized_keys)
                   children ++ [{SSHConsole, opts}]
               end

    opts = [strategy: :one_for_one, name: MakerionInit.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
