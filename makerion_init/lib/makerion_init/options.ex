defmodule MakerionInit.Options do
  @moduledoc false

  require Logger

  defstruct address_method: :dhcp,
    ifname: "wlan0",
    wifi_networks: nil,
    mdns_domain: "makerion.local"

  def get do
    maybe_copy_config()

    "/root/wifi.yml"
    |> read_config()
    |> case do
         {:ok, config} -> merge_defaults(config)
         error -> error
       end
  end

  defp merge_defaults(settings) do
    Map.merge(%__MODULE__{}, settings)
  end

  defp maybe_copy_config do
    maybe_config = Path.join("/boot", "wifi.yml")
    if File.exists?(maybe_config) do
      with {:ok, _config} <- read_config(maybe_config),
           :ok <- File.cp(maybe_config, "/root/wifi.yml") do
        File.rm(maybe_config)
      else
        {:error, message} ->
          Logger.error("Couldn't apply wifi configuration: #{inspect message}")
      end
    end
  end

  defp read_config(config_file) do
    with true <- File.exists?(config_file),
         {:ok, wifi} <- YamlElixir.read_from_file(config_file) do

      case Map.get(wifi, "networks") do
        networks = [_ | _] ->
          wifi_networks =
            networks
            |> Enum.map(fn(network) ->
            [
              ssid: network["ssid"],
              psk: network["psk"],
              priority: Map.get(network, "priority", 1),
              key_mgmt: String.to_atom(Map.get(network, "key_mgmt", "WPA-PSK"))
            ]
          end)

          {:ok, %{wifi_networks: wifi_networks}}

        _ ->
          {:error, "No networks defined"}
    else
      false ->
        {:error, "Config file does not exist"}
      {:error, %YamlElixir.ParsingError{}} ->
        {:error, "Config file not valid"}
    end
  end
end
