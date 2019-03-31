defprotocol Makerion.Printer do
  def get_status(printer_backend)
  def load_filament(printer_backend)
  def send_gcode(printer_backend, file_path)
  def unload_filament(printer_backend)
end

defimpl Makerion.Printer, for: Moddity.Driver do
  def get_status(_printer_backend) do
    case Moddity.Driver.get_status() do
      {:ok, status} ->
        %Makerion.PrinterStatus{
          state: translate_state(status["status"]["state"]),
          progress: status["job"]["progress"],
          extruder_target_temperature: status["status"]["extruder_target_temperature"],
          extruder_temperature: status["status"]["extruder_temperature"]
        }
      {:error, error} ->
        %Makerion.PrinterStatus{
          state: "Error",
          error: error
        }
    end
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

  defp translate_state("STATE_BUILDING"), do: "Building"
  defp translate_state("STATE_EXEC_PAUSE_CMD"), do: "Paused"
  defp translate_state("STATE_FILE_RX"), do: "Receiving File"
  defp translate_state("STATE_HOMING_HEATING"), do: "Heating"
  defp translate_state("STATE_HOMING_XY"), do: "Homing XY"
  defp translate_state("STATE_HOMING_Z_FINE"), do: "Homing Z Fine"
  defp translate_state("STATE_HOMING_Z_ROUGH"), do: "Home Z Rough"
  defp translate_state("STATE_IDLE"), do: "Idle"
  defp translate_state("STATE_JOB_CANCEL"), do: "Canceled"
  defp translate_state("STATE_JOB_PREP"), do: "Prep"
  defp translate_state("STATE_JOB_QUEUED"), do: "Job Queued"
  defp translate_state("STATE_LOADFIL_EXTRUDING"), do: "Extruding Filament"
  defp translate_state("STATE_LOADFIL_HEATING"), do: "Heating for Filament Load"
  defp translate_state("STATE_MECH_READY"), do: "Mech Ready"
  defp translate_state("STATE_NET_FAILED"), do: "Net Failed"
  defp translate_state("STATE_PAUSED"), do: "Paused"
  defp translate_state("STATE_REMFIL_HEATING"), do: "Heating for Filament Removal"
  defp translate_state("STATE_REMFIL_RETRACTING"), do: "Rectracting Filament"
  defp translate_state(state), do: state
end

defimpl Makerion.Printer, for: Moddity.FakeDriver do
  def get_status(_printer_backend) do
    {:ok, status} = Moddity.FakeDriver.get_status()
    %Makerion.PrinterStatus{
      state: translate_state(status["status"]["state"]),
      progress: status["job"]["progress"],
      extruder_target_temperature: status["status"]["extruder_target_temperature"],
      extruder_temperature: status["status"]["extruder_temperature"]
    }
  end

  def load_filament(_printer_backend) do
    Moddity.FakeDriver.load_filament()
  end

  def send_gcode(_printer_backend, file_path) do
    Moddity.FakeDriver.send_gcode(file_path)
  end

  def unload_filament(_printer_backend) do
    Moddity.FakeDriver.unload_filament()
  end

  defp translate_state("STATE_BUILDING"), do: "Building"
  defp translate_state("STATE_EXEC_PAUSE_CMD"), do: "Paused"
  defp translate_state("STATE_FILE_RX"), do: "Receiving File"
  defp translate_state("STATE_HOMING_HEATING"), do: "Heating"
  defp translate_state("STATE_HOMING_XY"), do: "Homing XY"
  defp translate_state("STATE_HOMING_Z_FINE"), do: "Homing Z Fine"
  defp translate_state("STATE_HOMING_Z_ROUGH"), do: "Home Z Rough"
  defp translate_state("STATE_IDLE"), do: "Idle"
  defp translate_state("STATE_JOB_CANCEL"), do: "Canceled"
  defp translate_state("STATE_JOB_PREP"), do: "Prep"
  defp translate_state("STATE_JOB_QUEUED"), do: "Job Queued"
  defp translate_state("STATE_LOADFIL_EXTRUDING"), do: "Loading Filament"
  defp translate_state("STATE_LOADFIL_HEATING"), do: "Heating"
  defp translate_state("STATE_MECH_READY"), do: "Mech Ready"
  defp translate_state("STATE_NET_FAILED"), do: "Net Failed"
  defp translate_state("STATE_PAUSED"), do: "Paused"
  defp translate_state("STATE_REMFIL_HEATING"), do: "Heating"
  defp translate_state("STATE_REMFIL_RETRACTING"), do: "Unloading Filament"
  defp translate_state(state), do: state
end