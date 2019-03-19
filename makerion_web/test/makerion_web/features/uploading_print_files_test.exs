defmodule MakerionWeb.UploadingPrintFilesTest do
  use MakerionWeb.FeatureCase

  alias Makerion.Print
  alias MakerionWeb.PrintFilesIndexPage

  hound_session()

  test "uploading a print file adds it to the listing" do
    navigate_to("/")
    name = "Tim's Awesome Print!"
    path = "print_fixture.gcode"
    fixture_file = Path.join([File.cwd!, "test", "fixtures", path])
    PrintFilesIndexPage.upload_file(name, fixture_file)
    all_print_files = PrintFilesIndexPage.all_print_files
    assert all_print_files == [%{name: name, path: path}]
  end
end
