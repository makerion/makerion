defmodule MakerionUpdater.FirmwareStatus do
  @moduledoc """
  Status of firmware upgrade availability
  """

  defstruct action: nil,
    current_version: nil,
    last_checked: nil,
    latest_version: nil,
    target_platform: nil

  @doc """
  Determines firmware current local version and remote latest version
  """
  def check(version_metadata, remote_release_client) do
    with {:ok, now} <- DateTime.now("Etc/UTC"),
         {:ok, current_version} <- current_version(version_metadata),
         {:ok, latest_version} <- latest_version(remote_release_client),
         target_platform <- target_platform(version_metadata) do

      status = %__MODULE__{
        action: nil,
        current_version: current_version,
        latest_version: latest_version,
        last_checked: now,
        target_platform: target_platform
      }

      {:ok, status}
    else
      error -> error
    end
  end

  @doc """
  Checks current version metadata against a remote release manager to see if an update is available
  """
  def update_available?(%__MODULE__{latest_version: nil}), do: false
  def update_available?(%__MODULE__{current_version: nil}), do: true

  def update_available?(%__MODULE__{current_version: current_version, latest_version: latest_version}) do
    case Version.compare(current_version, latest_version) do
      :lt -> true
      _ -> false
    end
  end

  def set_action(%__MODULE__{} = firmware_status, action) do
    %{firmware_status | action: action}
  end

  defp current_version(version_metadata) do
    Version.parse(version_metadata.get_active("nerves_fw_version"))
  end

  defp latest_version(remote_release_client) do
    case remote_release_client.get_latest_version() do
      {:ok, version} -> Version.parse(version)
      error -> error
    end
  end

  defp target_platform(version_metadata) do
    version_metadata.get_active("nerves_fw_platform")
  end
end
