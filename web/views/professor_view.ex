defmodule ClassSearch.ProfessorView do
  use ClassSearch.Web, :view

  def render("index.json", %{professors: professors}) do
    %{data: render_many(professors, ClassSearch.ProfessorView, "professor.json")}
  end

  def render("show.json", %{professor: professor}) do
    %{data: render_one(professor, ClassSearch.ProfessorView, "professor.json")}
  end

  def render("professor.json", %{professor: professor}) do
    %{id: professor.id,
      first_name: professor.first_name,
      last_name: professor.last_name,
      full_name: professor.full_name}
  end
end
