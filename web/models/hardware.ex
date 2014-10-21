defmodule HardwareZone.Hardware do
  use Ecto.Model
  validate hardware, name: present()

  schema "hardwares" do
    field :name, :string
    field :description
    field :manufacturer
    field :sale_contact_number
  end
end
