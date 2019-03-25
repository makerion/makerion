defmodule Makerion do
  def send_data(event_type, event_data) do
    Registry.dispatch(Registry.PrinterEvents, event_type, fn entries ->
      for {pid, _registered_val} <- entries do
        send(pid, {:printer_event, event_type, event_data})
      end
    end)
  end
end
