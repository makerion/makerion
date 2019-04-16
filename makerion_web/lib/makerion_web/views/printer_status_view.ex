defmodule MakerionWeb.PrinterStatusView do
  use MakerionWeb, :view

  def button_state(false), do: "disabled"
  def button_state(true), do: ""
end
