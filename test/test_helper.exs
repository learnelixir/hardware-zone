Phoenix.CodeReloader.reload!
ExUnit.start

defmodule SampleModel do
  defstruct id: 1, photo_file_size: 0, photo_file_name: nil, photo_content_type: nil, photo_updated_at: nil
end
