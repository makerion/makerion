defmodule MakerionWeb.FeatureCase do
  use ExUnit.CaseTemplate

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

  setup _tags do
    Hound.start_session()
    :ok
  end
end
