defmodule MakerionWeb.PrintingAFileTest do
  use MakerionWeb.FeatureCase, async: false

  alias Makerion.Print
  alias MakerionWeb.{PrinterActionsComponent, PrintFileComponent, PrintFilesIndexPage}

  hound_session()

  setup do
    path = "print_fixture.gcode"
    fixture_file = Path.join([File.cwd!, "test", "fixtures", path])
    {:ok, file} = Print.create_print_file(%{"name" => "Test Print", "path" => path, "tempfile" => fixture_file})
    {:ok, print_file: file}
  end

  test "printing a file disables action buttons", %{print_file: print_file} do
    navigate_to("/")

    print_file_element = PrintFilesIndexPage.print_file_element(print_file)
    PrintFileComponent.select_card(print_file_element)
    assert PrintFileComponent.print_button(print_file_element, disabled: false)
    assert PrinterActionsComponent.load_filament_button(disabled: false)
    assert PrinterActionsComponent.unload_filament_button(disabled: false)
    PrintFileComponent.click_print(print_file_element)
    assert PrintFileComponent.print_button(print_file_element, disabled: true)
    assert PrinterActionsComponent.load_filament_button(disabled: true)
    assert PrinterActionsComponent.unload_filament_button(disabled: true)
  end
end
