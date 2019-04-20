defmodule MakerionUpdaterTest do
  use ExUnit.Case
  doctest MakerionUpdater

  describe "update_available?" do
    test "returns true when a new version is available" do
      assert MakerionUpdater.update_available?(FakeOldVersionMetadata, FakeRemoteReleaseClient)
    end

    test "returns false when a new version is not available" do
      refute MakerionUpdater.update_available?(FakeNewVersionMetadata, FakeRemoteReleaseClient)
    end
  end

  describe "do_update!" do
    test "it fetches and applies firmware for the right version and board target" do
      assert :ok = MakerionUpdater.do_update!(FakeOldVersionMetadata, FakeRemoteReleaseClient)
    end
  end
end

defmodule FakeOldVersionMetadata do
  def get_active("nerves_fw_version"), do: "0.1.0"
  def get_active("nerves_fw_platform"), do: "fancy"
end

defmodule FakeNewVersionMetadata do
  def get_active("nerves_fw_version"), do: "3.0.0"
end

defmodule FakeRemoteReleaseClient do
  def get_latest_version, do: "3.0.0"
  def fetch_firmware(%Version{major: 3, minor: 0, patch: 0}, "fancy"), do: {:ok, "file"}
  def fetch_firmware(_, _), do: raise("called with bad update version or target board")
end
