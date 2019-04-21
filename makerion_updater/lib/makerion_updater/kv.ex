defmodule MakerionUpdater.KV do
  @moduledoc """
  local version metadata for host target
  """

  def get_active("nerves_fw_version") do
    [File.cwd!, "..", "VERSION"]
    |> Path.join()
    |> File.read!()
    |> String.trim()
  end

  def get_active("nerves_fw_platform") do
    "rpi3"
  end
end
