defmodule Makerion.PrinterStatus do
  @derive Jason.Encoder
  defstruct [:state, :progress, :extruder_target_temperature, :extruder_temperature]
end
