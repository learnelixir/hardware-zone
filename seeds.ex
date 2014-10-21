hardwares = [
  %{
    name: "Macbook Pro",
    description: "Looks like new, in good condition, used for 1.5 years",
    manufacturer: "Apple",
    sale_contact_number: "912345678"
  },
  %{
    name: "Toshiba CB35-B3340 Chromebook 2",
    description: "The new Chromebook 2 is thinner and lighter than its predecessor. Used for 2 years",
    manufacturer: "Toshiba",
    sale_contact_number: "987654321"
  },
  %{
    name: "HP Chromebook 11 (Verizon LTE)",
    description: "The design and construction of the laptop still looks good. Used for 1 year",
    manufacturer: "HP",
    sale_contact_number: "998765432"
  }
]

for hardware <- hardwares do
  new_hardware = Map.merge(%HardwareZone.Hardware{}, hardware)
  HardwareZone.Repo.insert(new_hardware)
end

