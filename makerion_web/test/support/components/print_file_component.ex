defmodule MakerionWeb.PrintFileComponent do
  @moduledoc """
  Test functions for interacting with a print file
  """

  use Hound.Helpers

  def select_card(print_file_element) do
    print_file_element
    |> click()
  end

  def click_print(print_file_element) do
    print_file_element
    |> print_button()
    |> click()
  end

  def print_button(print_file_element, opts \\ []) do
    opts
    |> Keyword.get(:disabled, false)
    |> case do
         true ->
           find_within_element(print_file_element, :css, "[data-test='print_file_button']:disabled")
         false ->
           find_within_element(print_file_element, :css, "[data-test='print_file_button']")
       end
  end
end
