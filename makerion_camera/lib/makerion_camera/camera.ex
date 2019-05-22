defmodule MakerionCamera.Camera do
  @moduledoc """
  This provides base camera functionality to the makerion app
  """

  use GenServer
  require Logger

  defdelegate next_frame(), to: Picam

  def start_link(opts \\ []) do
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(_opts) do
    Picam.set_size(1280, 720)
    Picam.set_img_effect(:normal)
    {:ok, %{}}
  end
end
