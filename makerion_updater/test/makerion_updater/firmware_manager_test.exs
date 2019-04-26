defmodule MakerionUpdater.FirmwareManagerTest do
  use ExUnit.Case, async: true

  import Mox

  alias MakerionUpdater.{FirmwareManager, FirmwareStatus, MockRemoteReleaseClient}

  doctest FirmwareManager

  setup :verify_on_exit!

  describe "with new version available" do
    defmodule FakeOldVersionMetadata do
      def get_active("nerves_fw_version"), do: "0.1.0"
      def get_active("nerves_fw_platform"), do: "fancy"
    end

    setup do
      {:ok, pid} = start_supervised({
        FirmwareManager,
        version_metadata: FakeOldVersionMetadata,
        remote_release_client: MockRemoteReleaseClient,
        poll: false,
        name: :test_old
          })
      {:ok, pid: pid}
    end

    test "returns true", %{pid: pid} do
      MockRemoteReleaseClient
      |> expect(:get_latest_version, fn -> {:ok, "3.0.0"} end)
      |> allow(self(), pid)

      assert FirmwareManager.update_available?(pid)
    end

    test "do_update fetches and applies firmware for the right version and board target", %{pid: pid} do
      FirmwareManager.subscribe()

      MockRemoteReleaseClient
      |> expect(:get_latest_version, fn -> {:ok, "3.0.0"} end)
      |> expect(:fetch_firmware, fn (%Version{major: 3, minor: 0, patch: 0}, "fancy") -> {:ok, "tempfile"} end)
      |> allow(self(), pid)

      assert FirmwareManager.update_available?(pid)
      assert :ok = FirmwareManager.do_update!(pid)
      assert_receive({:firmware_event, %FirmwareStatus{action: :downloading}}, 2_000)
      assert_receive({:firmware_event, %FirmwareStatus{action: :upgrading}}, 2_000)
      assert_receive({:firmware_event, %FirmwareStatus{action: :rebooting}}, 2_000)
    end
  end

  describe "update check with no new version available" do
    defmodule FakeNewVersionMetadata do
      def get_active("nerves_fw_version"), do: "3.0.0"
      def get_active("nerves_fw_platform"), do: "fancy"
    end

    setup do
      {:ok, pid} = start_supervised({
        FirmwareManager,
        version_metadata: FakeNewVersionMetadata,
        remote_release_client: MockRemoteReleaseClient,
        poll: false,
        name: :test_new
          })
      {:ok, pid: pid}
    end

    test "returns false", %{pid: pid} do
      MockRemoteReleaseClient
      |> expect(:get_latest_version, fn -> {:ok, "3.0.0"} end)
      |> allow(self(), pid)

      refute FirmwareManager.update_available?(pid)
    end
  end

  describe "event publishing" do
    defmodule OldVersionMetadata do
      def get_active("nerves_fw_version"), do: "0.1.0"
      def get_active("nerves_fw_platform"), do: "fancy"
    end

    setup do
      {:ok, pid} = start_supervised({
        FirmwareManager,
        version_metadata: OldVersionMetadata,
        remote_release_client: MockRemoteReleaseClient,
        name: :test_poll,
        delay_before_first_poll: 1_000
          })
      FirmwareManager.subscribe()
      {:ok, pid: pid}
    end

    test "it publishes a firmware event when an update is available", %{pid: pid} do
      MockRemoteReleaseClient
      |> expect(:get_latest_version, fn -> {:ok, "3.0.0"} end)
      |> allow(self(), pid)

      assert_receive({:firmware_event, %FirmwareStatus{}}, 2_000)
    end
  end
end
