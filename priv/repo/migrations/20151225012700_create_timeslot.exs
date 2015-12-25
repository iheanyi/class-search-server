defmodule ClassSearch.Repo.Migrations.CreateTimeslot do
  use Ecto.Migration

  def change do
    create table(:timeslots) do
      add :start_time, :time
      add :end_time, :time
      add :days_of_week, :string

      timestamps
    end

  end
end
