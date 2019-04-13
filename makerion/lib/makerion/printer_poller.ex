defmodule Makerion.PrinterPoller do
  @moduledoc """
  Proxies commands to the printer and polls for status updates
  """

  use GenServer

  alias Makerion.Printer

  def start_link(opts) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(opts) do
    printer_source = Keyword.get(opts, :printer_source)
    Process.send_after(self(), {:poll_status}, 1_000)
    {:ok, %{printer_source: printer_source, status: nil}}
  end

  def load_filament do
    GenServer.call(__MODULE__, {:load_filament}, 60_000)
  end

  def send_gcode(file_path) do
    GenServer.call(__MODULE__, {:send_gcode, file_path}, 60_000)
  end

  def unload_filament do
    GenServer.call(__MODULE__, {:unload_filament}, 60_000)
  end

  def handle_call({:load_filament}, _sender, state) do
    {:reply, Printer.load_filament(state.printer_source), state}
  end

  def handle_call({:send_gcode, file_path}, _sender, state) do
    {:reply, Printer.send_gcode(state.printer_source, file_path), state}
  end

  def handle_call({:unload_filament}, _sender, state) do
    {:reply, Printer.unload_filament(state.printer_source), state}
  end

  def handle_info({:poll_status}, state) do
    {:ok, printer_status} = Printer.get_status(state.printer_source)
    new_state = %{state | status: printer_status}
    send_data(:printer_status, printer_status)
    Process.send_after(self(), {:poll_status}, 1_000)
    {:noreply, new_state}
  end

  defp send_data(event_type, event_data) do
    Registry.dispatch(Registry.PrinterEvents, event_type, fn entries ->
      for {pid, _registered_val} <- entries do
        send(pid, {:printer_event, event_type, event_data})
      end
    end)
  end
end
