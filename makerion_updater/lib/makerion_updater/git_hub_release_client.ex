defmodule MakerionUpdater.GitHubReleaseClient do
  @moduledoc """
  Client to fetch release and artifact information from the GitHub Releases API
  """

  require Logger

  @project Application.get_env(:makerion_updater, :project)

  def get_latest_version do
    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <- HTTPoison.get("https://api.github.com/repos/#{@project}/releases/latest"),
         {:ok, decoded} <- Jason.decode(body) do

      decoded
      |> Map.get("name")
      |> String.replace_prefix("v", "")
    else
      error ->
        Logger.warn "Couldn't fetch latest release version: #{inspect error}"
        nil
    end
  end

  def fetch_firmware(%Version{major: major, minor: minor, patch: patch}, target_board) do
    version_string = "v#{major}.#{minor}.#{patch}"

    with {:ok, release_info} <- get_release_info(version_string),
         {:ok, firmware_url} <- get_firmware_file_url(release_info, version_string, target_board),
         uri <- URI.parse(firmware_url),
         basename <- Path.basename(uri.path),
         {:ok, firmware_response} <- HTTPoison.get(firmware_url, [], follow_redirect: true),
         :ok <- File.write(Path.join(firmware_dir(), basename), firmware_response.body, [:binary]),
         {:ok, firmware_sha256_response} <- HTTPoison.get("#{firmware_url}.sha256", [], follow_redirect: true),
         :ok <- File.write(Path.join(firmware_dir(), "#{basename}.sha256"), firmware_sha256_response.body, [:binary]),
         {calculated_sha256, 0} <- System.cmd("sha256sum", [Path.join(firmware_dir(), basename)]),
         {:ok, expected_sha256} <- File.read(Path.join(firmware_dir(), "#{basename}.sha256")) do

      # {_, 0} <- System.cmd("curl", [firmware_url, "-L", "-o", Path.join(firmware_dir(), basename)], stderr_to_stdout: true),
      # {_, 0} <- System.cmd("curl", ["#{firmware_url}.sha256", "-L", "-o", Path.join(firmware_dir(), "#{basename}.sha256")], stderr_to_stdout: true),

      calculated_hash = Enum.at(String.split(calculated_sha256, " "), 0)
      expected_hash = Enum.at(String.split(expected_sha256, " "), 0)

      case calculated_hash do
        ^expected_hash ->
          {:ok, Path.join(firmware_dir(), basename)}
        _ ->
          {:error, "Firmware hashes do not match.\nExpected:#{expected_hash}\nReceived:#{calculated_hash}"}
      end
    else
      error -> {:error, error}
    end
  end

  defp get_release_info(version_string) do
    "https://api.github.com/repos/#{@project}/releases/tags/#{version_string}"
    |> HTTPoison.get()
    |> case do
         {:ok, %HTTPoison.Response{body: body, status_code: 200}} ->
           Jason.decode(body)
         error ->
           error
       end
  end

  defp get_firmware_file_url(release_info, version_string, target_board) do
    matching_file = "#{target_board}_#{version_string}.fw"

    release_info
    |> Map.get("assets", [])
    |> Enum.map(fn (asset) -> Map.get(asset, "browser_download_url") end)
    |> Enum.find(fn (url) -> String.ends_with?(url, matching_file) end)
    |> case do
         firmware_url when not is_nil(firmware_url) ->
           {:ok, firmware_url}
         nil ->
           {:error, "Could not find mathing firmware file for #{matching_file}"}
       end
  end

  defp firmware_dir do
    firmware_path = Path.join("/root", "firmware")
    :ok = File.mkdir_p(firmware_path)
    firmware_path
  end
end
