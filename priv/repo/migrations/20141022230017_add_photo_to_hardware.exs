defmodule HardwareZone.Repo.Migrations.AddPhotoToHardware do
  use Ecto.Migration

  def up do
    "ALTER TABLE hardwares \
        ADD COLUMN photo_file_name varchar(255), \
        ADD COLUMN photo_content_type varchar(255), \
        ADD COLUMN photo_file_size integer, \
        ADD COLUMN photo_updated_at timestamp;"
  end

  def down do
    "ALTER TABLE hardwares \
        DROP COLUMN photo_file_name, 
        DROP COLUMN photo_content_type, 
        DROP COLUMN photo_file_size, 
        DROP COLUMN photo_updated_at;"
  end
end
