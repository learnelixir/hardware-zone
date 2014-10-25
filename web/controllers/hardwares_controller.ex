defmodule HardwareZone.HardwaresController do
  use Phoenix.Controller
  alias HardwareZone.Hardware
  alias HardwareZone.Repo
  alias HardwareZone.Router

  def index(conn, _params) do
    hardwares = HardwareZone.Queries.all_hardwares
    render conn, "index", hardwares: hardwares
  end

  def new(conn, _params) do
    render conn, "new", hardware: %Hardware{}
  end

  def create(conn, %{"hardware" => params}) do
    atomized_keys_params = atomize_keys(params)
    hardware = Map.merge(%Hardware{}, atomized_keys_params)
    case Hardware.validate(hardware) do
      [] ->
        hardware = Repo.insert(hardware)
        upload_photo_attachment(hardware, atomized_keys_params, :photo)
        redirect conn, Router.hardwares_path(:show, hardware.id)
      errors ->
        render conn, "new", hardware: hardware, errors: errors
    end
  end

  def show(conn, %{"id" => id}) do
    case Repo.get(Hardware, String.to_integer(id)) do
      hardware when is_map(hardware) ->
        render conn, "show", hardware: hardware
      _ -> 
        redirect conn, Router.hardwares_path(:index)
    end
  end

  def edit(conn, %{"id" => id}) do
    case Repo.get(Hardware, String.to_integer(id)) do
      hardware when is_map(hardware) ->
        render conn, "edit", hardware: hardware
      _ ->
        redirect conn, Router.hardwares_path(:index)
    end
  end

  def update(conn, %{"id" => id, "hardware" => params}) do
    case Repo.get(Hardware, String.to_integer(id)) do
      hardware when is_map(hardware) ->
        atomized_keys_params = atomize_keys(params)
        hardware = Map.merge(hardware, atomized_keys_params)
        case Hardware.validate(hardware) do
          [] -> 
            Repo.update(hardware)
            upload_photo_attachment(hardware, atomized_keys_params, :photo)
            redirect conn, Router.hardwares_path(:show, hardware.id)
          errors -> 
            render conn, "edit", hardware: hardware, errors: errors
        end
      _ ->
        redirect conn, Router.hardwares_path
    end
  end

  def destroy(conn, %{"id" => id}) do
    case Repo.get(Hardware, String.to_integer(id)) do
      hardware when is_map(hardware) ->
        Repo.delete(hardware)
        redirect conn, Router.hardwares_path(:index)
      _ ->
        redirect conn, Router.hardwares_path(:index)
    end
  end
  
  defp atomize_keys(struct) do
    Enum.reduce struct, %{}, fn({k, v}, map) -> Map.put(map, String.to_atom(k), v) end
  end

  defp upload_photo_attachment(hardware, params, attachment_attribute_name) do
    if params[attachment_attribute_name] do
      IO.puts (inspect hardware)
      hardware = UpPlug.process_upload_plug(%UpPlug{
        model: hardware,
        plug: params[attachment_attribute_name],
        attribute_name: attachment_attribute_name,
        styles: %{ thumb: "100x100>", large: "300x300>" }
      }, Repo)
      hardware = Map.delete(hardware, :photo)
      IO.puts(inspect hardware)
      result = Repo.update(hardware)
      IO.puts result
    end
  end
end
