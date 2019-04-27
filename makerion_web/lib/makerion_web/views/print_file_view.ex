defmodule MakerionWeb.PrintFileView do
  use MakerionWeb, :view

  alias Makerion.Print.PrintFile
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

  def is_selected?(%PrintFile{id: id}, id), do: true
  def is_selected?(_, _), do: false

  def card_selected_class(%PrintFile{id: id}, id), do: "card-selected"
  def card_selected_class(_, _), do: ""
end
