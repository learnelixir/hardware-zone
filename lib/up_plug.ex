defmodule UpPlug do
  import Mogrify
  defstruct plug: nil, model: nil, attribute_name: nil, styles: %{}

  def is_image?(plug) do
    content_type = plug.content_type
    image_mimes = [
      Plug.MIME.type("png"), 
      Plug.MIME.type("jpg"), 
      Plug.MIME.type("gif")
    ]
    Enum.find_index(image_mimes, fn(x) -> x == content_type end) != nil
  end

  def attachment_url_for(model, attribute_name, style \\ :original, default_url \\ nil ) do
    style = "#{style}"
    container_relative_path = attachment_container_relative_path(model, attribute_name)
    container_absolute_path = attachment_container_absolute_path(model, attribute_name)
    stored_file_name = Map.get(model, String.to_atom("#{attribute_name}_file_name")) 
    target_file = Enum.join([container_absolute_path, style, stored_file_name], "/")
    if File.exists?(target_file) do
      Enum.join(["", container_relative_path, style, stored_file_name], "/")
    else
      default_url 
    end
  end

  def attachment_exist?(model, attribute_name) do
    File.exists?(attachment_container_relative_path(model, attribute_name))
  end

  def attachment_container_relative_path(model, attribute_name) do
    Enum.join(["system", \
        Mix.Utils.underscore(model.__struct__), \
        attribute_name, \
        id_partition(model.id)], "/")
  end

  def attachment_container_absolute_path(model, attribute_name) do
    Enum.join([Mix.Project.app_path, "/priv/static", 
        attachment_container_relative_path(model, attribute_name)], "/")
  end

  def process_upload_plug(up_plug) do
    model = assign_file_information(up_plug)
    up_plug = Map.put(up_plug, :model, model)
    post_process_file(up_plug)
    up_plug.model
  end

  def assign_file_information(up_plug) do
    plug = up_plug.plug
    model = up_plug.model
    model = Map.put(model, \
                    String.to_atom("#{up_plug.attribute_name}_updated_at"), Ecto.DateTime.utc)
    model = Map.put(model, \
                    String.to_atom("#{up_plug.attribute_name}_content_type"), content_type(plug))
    model = Map.put(model, \
                    String.to_atom("#{up_plug.attribute_name}_file_name"), file_name(plug))
    model = Map.put(model, \
                    String.to_atom("#{up_plug.attribute_name}_file_size"), size(plug))
    model
  end

  def size(plug) do
    File.stat!(plug.path).size
  end

  def content_type(plug) do
    plug.content_type
  end

  def file_name(plug) do
    Regex.replace(~r/[&$+,\/:;=?@<>\[\]\{\}\|\\\^~%# ]/, plug.filename, "_")
  end

  def post_process_file(up_plug) do
    if up_plug.model.id do
      attachment_directory_path = \
        attachment_container_absolute_path(up_plug.model, up_plug.attribute_name)
      File.rm_rf(attachment_directory_path)
      File.mkdir_p(attachment_directory_path)
      store_original_file(up_plug, attachment_directory_path)
      if is_image?(up_plug.plug) do
        post_process_for_other_styles(up_plug, attachment_directory_path)
      end
    end
  end

  def store_original_file(up_plug, attachment_directory_path) do
    original_file_destination = Enum.join( \
      [attachment_directory_path, "original"], "/")
    File.mkdir_p(original_file_destination)
    File.copy(up_plug.plug.path, Enum.join( \
      [original_file_destination, file_name(up_plug.plug)], "/"), :infinity)
  end

  def post_process_for_other_styles(up_plug, attachment_directory_path) do
    styles = up_plug.styles
    if styles != nil do
      Enum.each styles, &post_process_for_style(&1, up_plug, attachment_directory_path)
    end
  end

  def post_process_for_style({style_name, style_size}, up_plug, attachment_directory_path) do
    saved_file_name = file_name(up_plug.plug)
    original_file_path = Enum.join( \
      [attachment_directory_path, "original", saved_file_name], "/")
    styled_file_destination = Enum.join( \
      [attachment_directory_path, style_name], "/")
    File.mkdir_p(styled_file_destination)
    open(original_file_path) 
      |> copy 
      |> resize(style_size) 
      |> save(Enum.join([styled_file_destination, saved_file_name], "/"))
  end

  def id_partition(id) do
    if id != nil do
      formatted_id = :io_lib.format("~9..0B", [id])  |> List.flatten |> to_string 
      Regex.scan(~r/\d{3}/, formatted_id) |> List.flatten |> Enum.join("/")
    else
      ""
    end
  end
end
