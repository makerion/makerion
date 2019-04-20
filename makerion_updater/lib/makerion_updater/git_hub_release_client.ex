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
    with {:ok, %HTTPoison.Response{body: body, status_code: 200}} <- HTTPoison.get("https://api.github.com/repos/#{@project}/releases/tags/#{version_string}"),
         {:ok, decoded} <- Jason.decode(body) do

      urls = Enum.map(Map.get(decoded, "assets", []), fn (asset) -> Map.get(asset, "browser_download_url") end)
      firmware_file = Enum.find(urls, fn (url) -> String.ends_with?(url, "#{target_board}_#{version_string}.fw") end)

      case firmware_file do
        nil -> Logger.error "Couldn't find firmware file"
        _ ->
          # System.cmd("curl", ["http://go.com"])
      end
    else
      error -> IO.inspect error
    end
  end
end
