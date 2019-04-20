defmodule MakerionWeb.PrintFileView do
  use MakerionWeb, :view

  alias Timex.Format.DateTime.Formatters.Relative

  def format_human(nil), do: nil

  def format_human(timestamp) do
    timestamp
    |> Relative.format("{relative}")
    |> case do
         {:ok, ago} -> ago
         _ -> nil
       end
  end

  def format_unix(nil), do: nil

  def format_unix(timestamp), do: DateTime.to_unix(timestamp)
end
