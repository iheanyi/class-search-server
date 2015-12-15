defmodule ClassSearch.DeserializePlug do
  def init(options) do
    options
  end

  def call(%Plug.Conn{params: %{"format" => "json-api"}, method: "POST"}=conn, _opts) do
    result = _deserialize(conn)
  end

  def call(%Plug.Conn{params: %{"format" => "json-api"}, method: "PUT"}=conn, _opts) do
    _deserialize(conn)
  end

  def call(%Plug.Conn{params: %{"format" => "json-api"}, method: "PATCH"}=conn, _opts) do
    _deserialize(conn)
  end

  def call(conn, _opts), do: conn

  defp _deserialize(%Plug.Conn{}=conn) do
    Map.put(conn, :params, _deserialize(conn.params))
  end

  defp _deserialize(%{}=params) do
    Enum.into(params, %{}, fn({key, value}) -> { _underscore(key), _deserialize(value) } end)
  end

  defp _deserialize(value), do: value
  defp _underscore(key), do: String.replace(key, "-", "_")
end
