defmodule ClassSearch.Repo.Migrations.CreateSectionTimeslot do
  use Ecto.Migration

  def change do
    create table(:section_timeslots) do
      add :begin_date, :date
      add :end_date, :date
      add :section_id, references(:sections, column: :crn, type: :integer)
      add :timeslot_id, references(:timeslots)
      
      timestamps
    end
    create index(:section_timeslots, [:section_id])
    create index(:section_timeslots, [:timeslot_id])

  end
end
