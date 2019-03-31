defmodule Makerion.PrinterPoller do
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
    # IO.puts "Getting printer_status"
    printer_status = Printer.get_status(state.printer_source)
    # IO.inspect printer_status
    new_state = %{state | status: printer_status}
    Makerion.send_data(:printer_status, printer_status)
    Process.send_after(self(), {:poll_status}, 1_000)
    {:noreply, new_state}
  end
end
