defmodule MakerionUpdater.RemoteReleaseClient do
  @moduledoc """
  A protocol to define the behaviors that a remote release client should implement
  """

  @doc """
  Fetches latest version information from the remote release repository
  """
  @callback get_latest_version() :: {:ok, binary()} | {:error, any()}

  @doc """
  Fetches the relevant release artifact for this platform for the given version

  Returns a string of the temp file for the new firmware artifact
  """
  @callback fetch_firmware(Version.t(), binary()) :: {:ok, binary()} | {:error, any()}
end
