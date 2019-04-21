defmodule MakerionUpdater.HostRuntime do
  @moduledoc """
  Implementation/fake for Nerves Runtime functions on the host machine
  """

  def cmd(_, _, _), do: {"success", 0}
  def reboot, do: :ok
end
