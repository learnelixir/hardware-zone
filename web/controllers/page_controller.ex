defmodule HardwareZone.PageController do
  use Phoenix.Controller

  def index(conn, _params) do
    render conn, "index.html"
  end

  def not_found(conn, _params) do
    render conn, "not_found.html"
  end

  def error(conn, _params) do
    render conn, "error.html"
  end
end
