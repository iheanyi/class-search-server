defmodule ClassSearch.SectionView do
  use ClassSearch.Web, :view

  def id(model, _conn), do: model.crn

  def render("index.json", %{sections: sections}) do
    %{data: render_many(sections, ClassSearch.SectionView, "section.json")}
  end

  def render("show.json", %{section: section}) do
    %{data: render_one(section, ClassSearch.SectionView, "section.json")}
  end

  def render("section.json", %{section: section}) do
    %{section_number: section.section_number,
      crn: section.crn,
      open_seats: section.open_seats,
      max_seats: section.max_seats,
      term_id: section.term_id,
      course_id: section.course_id,
      books_link: section.books_link}
  end
end
