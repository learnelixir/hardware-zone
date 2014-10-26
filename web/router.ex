defmodule HardwareZone.Router do
  use Phoenix.Router
  
  scope "/" do
    pipe_through :browser

    get "/", HardwareZone.HardwaresController, :index, as: :root
    resources "/hardwares", HardwareZone.HardwaresController
  end
end
