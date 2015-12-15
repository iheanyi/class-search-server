defmodule ClassSearch.DepartmentView do
  use ClassSearch.Web, :view

  def render("index.json", %{departments: departments}) do
    %{data: render_many(departments, ClassSearch.DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, ClassSearch.DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{name: department.name,
      tag: department.tag}
  end
end
