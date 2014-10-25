defmodule HardwareZone.Hardware do
  use Ecto.Model
  validate hardware, name: present()

  schema "hardwares" do
    field :name, :string
    field :description, :string
    field :manufacturer, :string
    field :sale_contact_number, :string
    field :photo_file_name, :string
    field :photo_file_size, :integer
    field :photo_updated_at, :datetime
    field :photo_content_type, :string
  end
end
