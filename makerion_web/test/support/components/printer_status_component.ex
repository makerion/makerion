defmodule MakerionWeb.PrinterStatusComponent do
  @moduledoc """
  Functions for interacting with the printer status component
  """

  use Hound.Helpers

  def printer_status do
    printer_status_element()
    |> find_all_within_element(:css, "[data-test='status_entry']")
    |> map_status_elements()
  end

  defp map_status_elements(status_elements) do
    Enum.reduce(status_elements, %{}, fn(element, acc) ->
      name = inner_html(find_within_element(element, :css, "[data-test='status_name']"))
      value = inner_html(find_within_element(element, :css, "[data-test='status_value']"))
      Map.put(acc, name, value)
    end)
  end

  defp printer_status_element do
    find_element(:css, "[data-test='printer_status']")
  end
end
