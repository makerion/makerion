defmodule MakerionCamera.Application do
  @moduledoc false

  use Application

  def start(_type, _args) do
    children = [
      Application.get_env(:picam, :camera, Picam.Camera),
      MakerionCamera.Camera
    ]

    opts = [strategy: :rest_for_one, name: MakerionCamera.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
