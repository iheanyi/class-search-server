defmodule ClassSearch.Repo.Migrations.CreateCourse do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :course_number, :string
      add :department_id, references(:departments, column: :tag, type: :string)

      timestamps
    end
    create index(:courses, [:department_id])

    # We want the course name and number to be unique together.
    # Cross-Listed courses will often have the same name.
    # We also want to make sure we have unique names per department.
    create unique_index(:courses, [:name, :course_number])
  end
end
