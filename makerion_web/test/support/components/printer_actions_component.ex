defmodule MakerionWeb.PrinterActionsComponent do
  @moduledoc """
  Functions for interacting with the printer actions component
  """

  use Hound.Helpers

  def load_filament_button(opts \\ []) do
    opts
    |> Keyword.get(:disabled, false)
    |> case do
         true ->
           find_within_element(printer_actions_element(), :css, "[data-test='load_filament_button']:disabled")
         false ->
           find_within_element(printer_actions_element(), :css, "[data-test='load_filament_button']")
       end
  end

  def unload_filament_button(opts \\ []) do
    opts
    |> Keyword.get(:disabled, false)
    |> case do
         true ->
           find_within_element(printer_actions_element(), :css, "[data-test='unload_filament_button']:disabled")
         false ->
           find_within_element(printer_actions_element(), :css, "[data-test='unload_filament_button']")
       end
  end

  defp printer_actions_element do
    find_element(:css, "[data-test='printer_actions']")
  end
end
