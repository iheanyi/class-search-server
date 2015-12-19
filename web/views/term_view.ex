defmodule ClassSearch.TermView do
  use ClassSearch.Web, :view
  
  attributes [:name, :tag]
  
  def id(model, _conn), do: model.tag
  
  def render("index.json", %{terms: terms}) do
    %{data: render_many(terms, ClassSearch.TermView, "term.json")}
  end

  def render("show.json", %{term: term}) do
    %{data: render_one(term, ClassSearch.TermView, "term.json")}
  end

  def render("term.json", %{term: term}) do
    %{name: term.name,
      tag: term.tag,
    }
  end
end
