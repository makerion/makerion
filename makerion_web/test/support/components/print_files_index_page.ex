defmodule MakerionWeb.PrintFilesIndexPage do
  use Hound.Helpers

  def all_print_files do
    find_all_elements(:css, "[data-test='print_file']")
    |> map_print_file_elements()
  end

  defp map_print_file_elements(print_file_elements) do
    Enum.map(print_file_elements, fn(element) ->
      name = inner_html(find_within_element(element, :css, "[data-test='print_file_name']"))
      path = inner_html(find_within_element(element, :css, "[data-test='print_file_path']"))
      %{name: name, path: path}
    end)
  end
end
