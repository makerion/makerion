defmodule MakerionInit.Options do
  @moduledoc false

  require Logger

  defstruct address_method: :dhcp,
    ifname: "wlan0",
    wifi_networks: nil,
    mdns_domain: "makerion.local",
    ssh_authorized_keys: nil,
    ssh_console_port: 22

  def get do
    maybe_copy_config()

    read_config()
    |> merge_defaults()
  end

  defp merge_defaults(settings) do
    Map.merge(%__MODULE__{}, settings)
  end

  defp maybe_copy_config do
    maybe_config = Path.join("/boot", "wifi.yml")
    if File.exists?(maybe_config) do
      with {:ok, _config} <- YamlElixir.read_from_file(maybe_config),
           :ok <- File.cp(maybe_config, "/root/wifi.yml") do
        File.rm(maybe_config)
      else
        {:error, message} ->
          Logger.error("Couldn't apply wifi configuration: #{inspect message}")
      end
    end
  end

  defp read_config do
    config = "/root/wifi.yml"
    if File.exists?(config) do
      {:ok, wifi} = YamlElixir.read_from_file(config)
      wifi_networks =
        wifi["networks"]
        |> Enum.map(fn(network) ->
             [
               ssid: network["ssid"],
               psk: network["psk"],
               priority: Map.get(network, "priority", 1),
               key_mgmt: String.to_atom(Map.get(network, "key_mgmt", "WPA-PSK"))
             ]
        end)

      opts = %{
        wifi_networks: wifi_networks,
        ssh_authorized_keys: wifi["ssh_authorized_keys"]
      }

      case wifi["mdns_domain"] do
        nil -> opts
        mdns_domain -> Map.put(opts, :mdns_domain, mdns_domain)
      end
    else
      %{}
    end
  end
end
