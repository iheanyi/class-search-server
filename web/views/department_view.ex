defmodule ClassSearch.DepartmentView do
  use ClassSearch.Web, :view

  attributes [:name, :tag]

  has_many :courses,
  include: true

  def id(model, _conn), do: model.tag

  def courses(model, conn) do
    case model.courses do
      %Ecto.Association.NotLoaded{} ->
        model
        |> Ecto.Model.assoc(:courses)
        |> ClassSearch.Repo.all
        other -> other
    end
  end
  
  def render("index.json", %{departments: departments}) do
    %{data: render_many(departments, ClassSearch.DepartmentView, "department.json")}
  end

  def render("show.json", %{department: department}) do
    %{data: render_one(department, ClassSearch.DepartmentView, "department.json")}
  end

  def render("department.json", %{department: department}) do
    %{name: department.name,
      tag: department.tag,
    }
  end
end
