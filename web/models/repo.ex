defmodule HardwareZone.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://postgresuser:password@localhost/hardware_zone"
  end

  def priv do
    app_dir(:hardware_zone, "priv/repo")
  end
end
