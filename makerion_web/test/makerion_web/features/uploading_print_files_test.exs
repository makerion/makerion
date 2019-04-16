defmodule MakerionWeb.UploadingPrintFilesTest do
  use MakerionWeb.FeatureCase

  alias MakerionWeb.PrintFilesIndexPage

  hound_session()

  test "uploading a print file adds it to the listing" do
    navigate_to("/")
    path = "print_fixture.gcode"
    fixture_file = Path.join([File.cwd!, "test", "fixtures", path])
    PrintFilesIndexPage.upload_file(fixture_file)
    assert PrintFilesIndexPage.print_file_element(%{path: path})
  end
end
