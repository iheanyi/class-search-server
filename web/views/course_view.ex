defmodule ClassSearch.CourseView do
  use ClassSearch.Web, :view

  location "/courses/:id"
  attributes [:course_number, :name]

  def render("index.json", %{courses: courses}) do
    %{data: render_many(courses, ClassSearch.CourseView, "course.json")}
  end

  def render("show.json", %{course: course}) do
    %{data: render_one(course, ClassSearch.CourseView, "course.json")}
  end

  def render("course.json", %{course: course}) do
    %{id: course.id,
      name: course.name,
      course_number: course.course_number,
      department_id: course.department_id}
  end
end
