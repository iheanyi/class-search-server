defmodule ClassSearch.Repo.Migrations.CreateSection do
  use Ecto.Migration

  def change do
    create table(:sections, primary_key: false) do
      add :section_number, :integer
      add :crn, :integer, primary_key: true
      add :open_seats, :integer
      add :max_seats, :integer
      add :books_link, :string
      add :term_id, references(:terms, column: :tag, type: :integer)
      add :course_id, references(:courses)

      timestamps
    end
    create index(:sections, [:term_id])
    create index(:sections, [:course_id])

    create unique_index(:sections, [:section_number, :term_id, :course_id])
  end
end
