defmodule HardwareZone.Queries do
  import Ecto.Query

  def all_hardwares do
    query = from hardware in HardwareZone.Hardware, \
            select: hardware

    HardwareZone.Repo.all(query)
  end
end
