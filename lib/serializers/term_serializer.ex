defmodule ClassSearch.TermSerializer do
  use JaSerializer

  attributes [:name, :tag]

  def id(model, _conn), do: model.tag
end
