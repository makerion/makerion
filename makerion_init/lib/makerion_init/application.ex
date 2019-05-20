defmodule MakerionInit.Application do
  @moduledoc false

  use Application

  alias MakerionInit.{Options, NetworkManager, SSHConsole}

  def start(_type, _args) do
    opts = Options.get()

    children = [{NetworkManager, opts}]
    children = case Map.get(opts, :ssh_authorized_keys) do
                 nil ->
                   stop_firmware_ssh()
                   children
                 authorized_keys ->
                   update_firmware_ssh_config(authorized_keys)
                   children ++ [{SSHConsole, opts}]
               end

    opts = [strategy: :one_for_one, name: MakerionInit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  defp stop_firmware_ssh do
    Application.stop(:nerves_firmware_ssh)
    Application.stop(:ssh)
  end

  defp update_firmware_ssh_config(authorized_keys) do
    stop_firmware_ssh()
    # Update firmware ssh config as well - TODO this is hacky
    Application.put_env(:nerves_firmware_ssh, :authorized_keys, authorized_keys)
    Application.start(:nerves_firmware_ssh)
    Application.start(:ssh)
  end
end
