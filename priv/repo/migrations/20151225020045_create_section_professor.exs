defmodule ClassSearch.Repo.Migrations.CreateSectionProfessor do
  use Ecto.Migration

  def change do
    create table(:section_professors) do
      add :professor_id, references(:professors)
      add :section_id, references(:sections, column: :crn, type: :integer)

      timestamps
    end
    create index(:section_professors, [:professor_id])
    create index(:section_professors, [:section_id])

  end
end
