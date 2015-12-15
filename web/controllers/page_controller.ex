defmodule ClassSearch.PageController do
  use ClassSearch.Web, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
