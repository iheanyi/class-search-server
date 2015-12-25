defmodule ClassSearch.CourseView do
  use ClassSearch.Web, :view

  attributes [:course_number, :name]
  
  #has_one :department,
  #serializer: ClassSearch.DepartmentView,
  #include: true

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
