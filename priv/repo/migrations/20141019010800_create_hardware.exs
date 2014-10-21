defmodule HardwareZone.Repo.Migrations.CreateHardware do
  use Ecto.Migration

  def up do
    "CREATE TABLE hardwares(\
            id serial primary key, \
            name varchar(125), \
            description text, \
            manufacturer varchar(255), \
            sale_contact_number varchar(255))"
  end

  def down do
    "DROP TABLE hardwares"
  end
end
