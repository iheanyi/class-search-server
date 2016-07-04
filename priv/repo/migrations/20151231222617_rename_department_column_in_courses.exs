defmodule ClassSearch.Repo.Migrations.RenameDepartmentColumnInCourses do
  use Ecto.Migration

  def change do
    rename table(:courses), :department_id, to: :department_tag
  end
end
