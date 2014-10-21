use Mix.Config

config :phoenix, HardwareZone.Router,
  port: System.get_env("PORT") || 4001,
  ssl: false,
  cookies: true,
  session_key: "_hardware_zone_key",
  session_secret: "VQP)JU1Z7*5L+^09X*L=6RKN9R1HL0O2E7^(1B%V3W64Z7@J9^7(M&TXW8*C)IRW!N=)D40XZ&K+^XBQ1"

config :phoenix, :code_reloader,
  enabled: true

config :logger, :console,
  level: :debug


