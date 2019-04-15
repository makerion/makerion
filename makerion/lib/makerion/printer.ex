require Protocol
Protocol.derive(Jason.Encoder, Moddity.PrinterStatus)

defprotocol Makerion.Printer do
  @fallback_to_any true

  def get_status(printer_backend)
  def load_filament(printer_backend)
  def send_gcode(printer_backend, file_path)
  def unload_filament(printer_backend)
end

defimpl Makerion.Printer, for: Moddity.Driver do
  def get_status(_printer_backend) do
    Moddity.Driver.get_status()
  end

  def load_filament(_printer_backend) do
    Moddity.Driver.load_filament()
  end

  def send_gcode(_printer_backend, file_path) do
    Moddity.Driver.send_gcode(file_path)
  end

  def unload_filament(_printer_backend) do
    Moddity.Driver.unload_filament()
  end
end

defimpl Makerion.Printer, for: Any do
  def get_status(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def load_filament(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def send_gcode(printer_backend, _file_path), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def unload_filament(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
end
