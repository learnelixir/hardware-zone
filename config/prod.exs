use Mix.Config

# NOTE: To get SSL working, you will need to set:
#
#     ssl: true,
#     keyfile: System.get_env("SOME_APP_SSL_KEY_PATH"),
#     certfile: System.get_env("SOME_APP_SSL_CERT_PATH"),
#
# Where those two env variables point to a file on disk
# for the key and cert

config :phoenix, HardwareZone.Router,
  port: System.get_env("PORT"),
  ssl: false,
  host: "example.com",
  cookies: true,
  session_key: "_hardware_zone_key",
  session_secret: "VQP)JU1Z7*5L+^09X*L=6RKN9R1HL0O2E7^(1B%V3W64Z7@J9^7(M&TXW8*C)IRW!N=)D40XZ&K+^XBQ1"

config :logger, :console,
  level: :info,
  metadata: [:request_id]

