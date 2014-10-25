defmodule UpPlugTest do
  use ExUnit.Case, async: true
  import UpPlug
  
  setup do
    {
      :ok, \
      sample_image_plug: %Plug.Upload{ \
        content_type: "image/png", \
        filename: "sample.png", \
        path: "#{Path.expand("../", __DIR__)}/sample_data/sample.png" \
      }, \
      sample_document_plug: %Plug.Upload{ \
        content_type: "application/pdf", \
        filename: "sample.pdf", \
        path:  "#{Path.expand("../", __DIR__)}/sample_data/sample.pdf" \
      }, \
      model_struct: %SampleModel{}, \
      photo_attribute_name: :photo,
      document_attribute_name: :spec
    }
  end

  setup context do 
    {
      :ok, 
      Map.put(context, :up_plug, %UpPlug{ \
        plug: context[:sample_image_plug], \
        model: context[:model_struct],  \
        attribute_name: context[:photo_attribute_name], \
        styles: %{
          thumb: "50x50>",
          medium: "120x120>" 
        }
      }) |>  
      Map.put(:document_up_plug, %UpPlug{ \
        plug: context[:sample_document_plug], \
        model: context[:model_struct],
        attribute_name: context[:document_attribute_name]
      })
    }
  end

  test "is_image? returns true if upload file is image", context do
    assert is_image?(context[:sample_image_plug]) == true
  end

  test "is_image? returns false if upload file is not an image", context do
    refute is_image?(context[:sample_document_plug])
  end

  test "returns 000/000/001 for id_partition call with id 1" do
    assert id_partition(1) == "000/000/001"
  end

  test "returns 000/120/501 for id_partition call with id 120501" do
    assert id_partition(120501) == "000/120/501"
  end

  test "assigns photo_updated_at attribute after saving the photo", context do
    model = process_upload_plug(context[:up_plug]) 
    assert model.photo_updated_at.__struct__ == Ecto.DateTime
  end
  
  test "assigns photo_content_type attribute after saving the photo", context do
    model = process_upload_plug(context[:up_plug])
    assert model.photo_content_type == context[:sample_image_plug].content_type 
  end

  test "assigns photo_file_name attribute after saving the photo", context do
    model = process_upload_plug(context[:up_plug])
    assert model.photo_file_name == context[:sample_image_plug].filename
  end

  test "replaces special character in file name with _", context do
    new_plug = Map.put(context[:up_plug].plug, :filename, "a&b+c?d;e@f>g<h|i^j#k%l\\m,n=o.png")
    new_up_plug = Map.put(context[:up_plug], :plug, new_plug)
    model = process_upload_plug(new_up_plug)
    assert model.photo_file_name == "a_b_c_d_e_f_g_h_i_j_k_l_m_n_o.png"
  end

  test "assigns the photo_file_size attribute after saving the photo", context do
    model = process_upload_plug(context[:up_plug])
    assert model.photo_file_size == 917350 
  end

  test "stores uploaded image in original folder", context do
    process_upload_plug(context[:up_plug])
    expected_original_file_path = \
      "#{Mix.Project.app_path}/priv/static/system/sample_model/photo/000/000/001/original/sample.png"
    assert File.exists?(expected_original_file_path)
  end

 test "stores extra styled images in corresponding folder", context do
    process_upload_plug(context[:up_plug])
    expected_thumb_file_path = \
      "#{Mix.Project.app_path}/priv/static/system/sample_model/photo/000/000/001/thumb/sample.png"
    assert File.exists?(expected_thumb_file_path)
    
    expected_medium_file_path = \
      "#{Mix.Project.app_path}/priv/static/system/sample_model/photo/000/000/001/medium/sample.png"
    assert File.exists?(expected_medium_file_path)
  end

  test "stores uploaded document in original folder", context do
    process_upload_plug(context[:document_up_plug])
    expected_original_file_path = \
      "#{Mix.Project.app_path}/priv/static/system/sample_model/spec/000/000/001/original/sample.pdf"
    assert File.exists?(expected_original_file_path)
  end

  test "returns correct url for original image", context do
    model = process_upload_plug(context[:up_plug])
    assert attachment_url_for( \
        model, \
        context[:photo_attribute_name]) == "/system/sample_model/photo/000/000/001/original/sample.png"
  end

  test "returns correct url for a styled image", context do
    model = process_upload_plug(context[:up_plug])
    assert attachment_url_for( \
        model, \
        context[:photo_attribute_name], \
        :thumb) == "/system/sample_model/photo/000/000/001/thumb/sample.png"

  end
end
