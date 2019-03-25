defmodule MakerionFirmware.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  @target Mix.target()

  use Application

  def start(_type, _args) do
    if @target != :host do
      start_network()
    end

    :ok = setup_db!()

    opts = [strategy: :one_for_one, name: MakerionFirmware.Supervisor]
    Supervisor.start_link(children(@target), opts)
  end

  # List all child processes to be supervised
  def children(:host) do
    [
      # Starts a worker by calling: MakerionFirmware.Worker.start_link(arg)
      # {MakerionFirmware.Worker, arg},
    ]
  end

  def children(_target) do
    [
      # Starts a worker by calling: MakerionFirmware.Worker.start_link(arg)
      # {MakerionFirmware.Worker, arg},
    ]
  end

  def start_network do
    maybe_config = Path.join("/boot", "wifi.yml")
    if File.exists?(maybe_config) do
      with {:ok, _config} <- YamlElixir.read_from_file(maybe_config),
           :ok <- File.cp(maybe_config, "/root/wifi.yml") do
        File.rm(maybe_config)
      end
    end

    config = "/root/wifi.yml"
    if File.exists?(config) do
      {:ok, wifi} = YamlElixir.read_from_file(config)
      networks =
        wifi["networks"]
        |> Enum.map(fn(network) ->
          [
            ssid: network["ssid"],
            psk: network["psk"],
            priority: Map.get(network, "priority", 1),
            key_mgmt: Map.get(network, "key_mgmt", "WPA-PSK") |> String.to_atom()
          ]
        end)

      settings = [networks: networks]
      Nerves.Network.setup("wlan0", settings)
    end
  end

  defp setup_db! do
    repos = Application.get_env(:makerion, :ecto_repos)
    for repo <- repos do
      if Application.get_env(:makerion, repo)[:adapter] == Sqlite.Ecto2 do
        setup_repo!(repo)
        migrate_repo!(repo)
      end
    end
    :ok
  end

  defp setup_repo!(repo) do
    db_file = Application.get_env(:makerion, repo)[:database]
    unless File.exists?(db_file) do
      :ok = repo.__adapter__.storage_up(repo.config)
    end
  end

  defp migrate_repo!(repo) do
    opts = [all: true]
    {:ok, pid, apps} = Mix.Ecto.ensure_started(repo, opts)

    migrator = &Ecto.Migrator.run/4
    pool = repo.config[:pool]
    migrations_path = Path.join([:code.priv_dir(:makerion) |> to_string, "repo", "migrations"])
    migrated =
    if function_exported?(pool, :unboxed_run, 2) do
      pool.unboxed_run(repo, fn -> migrator.(repo, migrations_path, :up, opts) end)
    else
      migrator.(repo, migrations_path, :up, opts)
    end

    pid && repo.stop(pid)
    Mix.Ecto.restart_apps_if_migrated(apps, migrated)
  end
end
