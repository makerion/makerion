defmodule MakerionWeb.ShowingPrinterStatusTest do
  use MakerionWeb.FeatureCase

  alias MakerionWeb.PrinterStatusComponent

  hound_session()

  test "it shows the status of a connected printer" do
    navigate_to("/")
    status = PrinterStatusComponent.printer_status
    assert %{"State" => _} = status
  end
end
