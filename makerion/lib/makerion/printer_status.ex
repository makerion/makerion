defmodule Makerion.PrinterStatus do
  @moduledoc false
  @derive Jason.Encoder
  defstruct [:state, :progress, :extruder_target_temperature, :extruder_temperature, :error]
end
