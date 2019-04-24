defmodule MakerionInit.NetworkManager do
  @moduledoc false

  use GenServer

  require Logger

  alias MakerionInit.Options

  defmodule State do
    @moduledoc false
    defstruct ip: nil, is_up: nil, opts: nil
  end

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts)
  end

  def init(opts) do
    # Register for updates from system registry
    SystemRegistry.register()

    state =
      %State{opts: opts}
      |> start_network(opts)
      |> init_mdns(opts)

    {:ok, state}
  end

  def handle_info({:system_registry, :global, registry}, state) do
    {changed, new_state} = update_state(state, registry)

    case changed do
      :up -> handle_if_up(new_state)
      :down -> handle_if_down(new_state)
      _ -> :ok
    end

    {:noreply, new_state}
  end

  defp update_state(%{opts: %{address_method: :dhcpd}} = state, registry) do
    # Trigger off `:is_lower_up`. The "lower" comes up after a delay on some
    # interfaces. If things are configured before the "lower" is up then
    # packets down get received. This results in weird behavior like the DHCP
    # server not receiving anything until a packet gets sent.
    new_is_up = get_in(registry, [:state, :network_interface, state.opts.ifname, :is_lower_up])

    case {new_is_up == state.is_up, new_is_up} do
      {true, _} -> {:unchanged, state}
      {false, true} -> {:up, %{state | is_up: true}}
      {false, _is_up} -> {:down, %{state | is_up: new_is_up}}
    end
  end

  defp update_state(state, registry) do
    new_ip = get_in(registry, [:state, :network_interface, state.opts.ifname, :ipv4_address])

    case {new_ip == state.ip, new_ip} do
      {true, _} -> {:unchanged, state}
      {false, nil} -> {:down, %{state | ip: nil, is_up: false}}
      {false, _ip} -> {:up, %{state | ip: new_ip, is_up: true}}
    end
  end

  defp start_network(%State{} = state, %Options{wifi_networks: networks}) do
    Nerves.Network.setup(state.opts.ifname, networks: networks)
    state
  end

  defp handle_if_up(state) do
    Logger.debug("#{state.opts.ifname} is up. IP is now #{state.ip}")

    update_mdns(state.ip, state.opts.mdns_domain)
  end

  defp handle_if_down(_state), do: :ok

  defp init_mdns(state, %{mdns_domain: nil}), do: state

  defp init_mdns(state, opts) do
    Mdns.Server.add_service(%Mdns.Server.Service{
          domain: resolve_mdns_name(opts.mdns_domain),
          data: :ip,
          ttl: 120,
          type: :a
})

    state
  end

  defp update_mdns(_ip, nil), do: :ok

  defp update_mdns(ip, _mdns_domain) do
    ip_tuple = string_to_ip(ip)
    Mdns.Server.stop()

    # Give the interface time to settle to fix an issue where mDNS's multicast
    # membership is not registered. This occurs on wireless interfaces and
    # needs to be revisited.
    :timer.sleep(100)

    Mdns.Server.start(interface: ip_tuple)
    Mdns.Server.set_ip(ip_tuple)
  end

  defp string_to_ip(s) do
    {:ok, ip} = :inet.parse_address(to_charlist(s))
    ip
  end

  defp resolve_mdns_name(nil), do: nil

  defp resolve_mdns_name(:hostname) do
    {:ok, hostname} = :inet.gethostname()

    to_dot_local_name(hostname)
  end

  defp resolve_mdns_name(mdns_name), do: mdns_name

  defp to_dot_local_name(name) do
    # Use the first part of the domain name and concatenate '.local'
    name
    |> to_string()
    |> String.split(".")
    |> hd()
    |> Kernel.<>(".local")
  end
end
