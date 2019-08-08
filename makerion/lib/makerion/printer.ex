require Protocol
Protocol.derive(Jason.Encoder, Moddity.PrinterStatus)

defprotocol Makerion.Printer do
  @fallback_to_any true

  def abort_print(printer_backend)
  def get_status(printer_backend)
  def load_filament(printer_backend)
  def pause_printer(printer_backend)
  def reset_printer(printer_backend)
  def resume_printer(printer_backend)
  def send_gcode(printer_backend, file_path)
  def send_gcode_command(printer_backend, line)
  def unload_filament(printer_backend)
end

defimpl Makerion.Printer, for: Moddity.Driver do
  def abort_print(_printer_backend) do
    Moddity.Driver.abort_print()
  end

  def get_status(_printer_backend) do
    Moddity.Driver.get_status()
  end

  def load_filament(_printer_backend) do
    Moddity.Driver.load_filament()
  end

  def pause_printer(_printer_backend) do
    Moddity.Driver.pause_printer()
  end

  def reset_printer(_printer_backend) do
    Moddity.Driver.reset_printer()
  end

  def resume_printer(_printer_backend) do
    Moddity.Driver.resume_printer()
  end

  def send_gcode(_printer_backend, file_path) do
    Moddity.Driver.send_gcode(file_path)
  end

  def send_gcode_command(_printer_backend, line) do
    Moddity.Driver.send_gcode_command(line)
  end

  def unload_filament(_printer_backend) do
    Moddity.Driver.unload_filament()
  end
end

defimpl Makerion.Printer, for: Any do
  def abort_print(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def get_status(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def load_filament(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def pause_printer(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def reset_printer(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def resume_printer(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def send_gcode(printer_backend, _file_path), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def send_gcode_command(printer_backend, _line), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
  def unload_filament(printer_backend), do: {:error, "No implementation found for #{inspect(printer_backend)}"}
end
