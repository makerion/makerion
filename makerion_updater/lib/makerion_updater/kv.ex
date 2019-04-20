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
end
