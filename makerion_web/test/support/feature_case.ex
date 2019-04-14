defmodule MakerionWeb.FeatureCase do
  @moduledoc false

  use ExUnit.CaseTemplate

  alias Ecto.Adapters.SQL.Sandbox

  using do
    quote do
      # Import conveniences for testing with connections
      # use Phoenix.ConnTest
      use Hound.Helpers
      # alias MakerionWeb.Router.Helpers, as: Routes

      # The default endpoint for testing
      # @endpoint MakerionWeb.Endpoint
    end
  end

  setup tags do
    Hound.start_session()

    :ok = Sandbox.checkout(Makerion.Repo)

    unless tags[:async] do
      Sandbox.mode(Makerion.Repo, {:shared, self()})
    end

    :ok
  end
end
