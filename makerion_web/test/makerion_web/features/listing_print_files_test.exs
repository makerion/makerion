defmodule MakerionWeb.ListingPrintFilesTest do
  use MakerionWeb.FeatureCase

  alias Makerion.Print
  alias MakerionWeb.PrintFilesIndexPage

  hound_session()

  setup do
    {:ok, file} = Print.create_print_file(%{name: "Test Print", path: "test_path.gcode"})
    {:ok, print_file: file}
  end

  test "it lists files", %{print_file: print_file} do
    navigate_to("/")
    all_print_files = PrintFilesIndexPage.all_print_files
    assert all_print_files == [%{name: print_file.name, path: print_file.path}]
  end
end
