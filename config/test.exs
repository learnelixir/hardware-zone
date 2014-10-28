use Mix.Config

config :phoenix, HardwareZone.Router,
  http: [port: System.get_env("PORT") || 4001],
  catch_errors: false
