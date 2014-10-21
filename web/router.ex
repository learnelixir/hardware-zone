defmodule HardwareZone.Router do
  use Phoenix.Router

  get "/", HardwareZone.HardwaresController, :index, as: :root
  resources "/hardwares", HardwareZone.HardwaresController
end
