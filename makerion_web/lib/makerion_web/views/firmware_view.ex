defmodule MakerionWeb.FirmwareView do
  use MakerionWeb, :view

  alias MakerionUpdater.FirmwareStatus

  def to_human(%FirmwareStatus{action: nil}), do: nil
  def to_human(%FirmwareStatus{action: :downloading}), do: "Downloading Firmware"
  def to_human(%FirmwareStatus{action: :upgrading}), do: "Upgrading Firmware"
  def to_human(%FirmwareStatus{action: :rebooting}), do: "Rebooting"
end
