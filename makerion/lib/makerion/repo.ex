defmodule Makerion.Repo do
  use Ecto.Repo, otp_app: :makerion, adapter: Sqlite.Ecto2
end
