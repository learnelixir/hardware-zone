defmodule HardwareZone.Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    parse_url "ecto://gnukdiprjdibvv:@ec2-54-197-250-40.compute-1.amazonaws.com/d9v5t7afd4osse"
  end

  def priv do
    app_dir(:hardware_zone, "priv/repo")
  end
end
