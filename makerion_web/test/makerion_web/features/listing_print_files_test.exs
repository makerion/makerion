defmodule MakerionWeb.ListingPrintFilesTest do
  use MakerionWeb.FeatureCase

  alias Makerion.Print
  alias MakerionWeb.PrintFilesIndexPage

  hound_session()

  setup do
    path = "print_fixture.gcode"
    fixture_file = Path.join([File.cwd!, "test", "fixtures", path])
    {:ok, file} = Print.create_print_file(%{"name" => "Test Print", "path" => path, "tempfile" => fixture_file})
    {:ok, print_file: file}
  end

  test "it lists files", %{print_file: print_file} do
    navigate_to("/")
    all_print_files = PrintFilesIndexPage.all_print_files

    assert 1 == Enum.count(all_print_files)
    assert print_file.name == hd(all_print_files).name
    assert print_file.path == hd(all_print_files).path
  end

  test "print files show the last printed time", %{print_file: print_file} do
    :ok = Print.start_print(print_file)
    print_file = Print.get_print_file!(print_file.id)

    navigate_to("/")
    all_print_files = PrintFilesIndexPage.all_print_files

    refute is_nil(print_file.last_printed_at)
    assert DateTime.to_unix(print_file.last_printed_at) == hd(all_print_files).last_printed_at
  end
end
