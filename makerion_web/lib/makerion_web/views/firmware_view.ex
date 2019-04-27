defmodule MakerionWeb.FirmwareView do
  use MakerionWeb, :view

  alias MakerionUpdater.FirmwareStatus

  def to_human(%FirmwareStatus{action: nil}), do: nil
  def to_human(%FirmwareStatus{action: :downloading}), do: "Downloading Firmware"
  def to_human(%FirmwareStatus{action: :upgrading}), do: "Upgrading Firmware"
  def to_human(%FirmwareStatus{action: :rebooting}), do: "Rebooting"

  def percent_complete(%FirmwareStatus{action: nil}), do: "width: 0"
  def percent_complete(%FirmwareStatus{action: :downloading}), do: "width: 33%"
  def percent_complete(%FirmwareStatus{action: :upgrading}), do: "width: 67%"
  def percent_complete(%FirmwareStatus{action: :rebooting}), do: "width: 100%"
end
