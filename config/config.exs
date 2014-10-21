# This file is responsible for configuring your application
use Mix.Config

# Note this file is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project.

config :phoenix, HardwareZone.Router,
  port: System.get_env("PORT"),
  ssl: false,
  static_assets: true,
  cookies: true,
  session_key: "_hardware_zone_key",
  session_secret: "VQP)JU1Z7*5L+^09X*L=6RKN9R1HL0O2E7^(1B%V3W64Z7@J9^7(M&TXW8*C)IRW!N=)D40XZ&K+^XBQ1",
  catch_errors: true,
  debug_errors: false,
  error_controller: HardwareZone.PageController

config :phoenix, :code_reloader,
  enabled: false

config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Import environment specific config. Note, this must remain at the bottom of
# this file to properly merge your previous config entries.
import_config "#{Mix.env}.exs"
