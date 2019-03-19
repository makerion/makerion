defmodule MakerionWeb.PrintFilesIndexPage do
  use Hound.Helpers

  def all_print_files do
    find_all_elements(:css, "[data-test='print_file']")
    |> map_print_file_elements()
  end

  def upload_file(name, file) do
    click({:css, "[data-test='upload_new_file']"})

    file_input = find_element(:css, "[data-test='print_file_file_input']")
    attach_file(file_input, file)

    fill_field({:css, "[data-test='print_file_name']"}, name)
    click({:css, "[data-test='upload_print_file_submit']"})
  end

  defp attach_file(element, file_path) do
    import Hound.RequestUtils # import make_req function
    session_id = Hound.current_session_id
    response = make_req(:post, "session/#{session_id}/element/#{element}/value", %{value: ["#{file_path}"]})
    response
  end

  defp map_print_file_elements(print_file_elements) do
    Enum.map(print_file_elements, fn(element) ->
      name = inner_html(find_within_element(element, :css, "[data-test='print_file_name']"))
      path = inner_html(find_within_element(element, :css, "[data-test='print_file_path']"))
      %{name: name, path: path}
    end)
  end
end
