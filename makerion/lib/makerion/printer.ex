defprotocol Makerion.Printer do
  def get_status(printer_backend)
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

  defp translate_state("STATE_IDLE"), do: "Idle"
  defp translate_state("STATE_FILE_RX"), do: "Receiving File"
  defp translate_state("STATE_JOB_QUEUED"), do: "Job Queued"
  defp translate_state("STATE_BUILDING"), do: "Building"
  defp translate_state("STATE_NET_FAILED"), do: "Net Failed"
  defp translate_state("STATE_EXEC_PAUSE_CMD"), do: "Paused"

  defp translate_state(state), do: state
end
