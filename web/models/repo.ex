defmodule HardwareZone.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://postgresuser:postgrespassword@127.0.0.1/hardware_zone"
  end

  def priv do
    app_dir(:hardware_zone, "priv/repo")
  end
end
