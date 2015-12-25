defmodule ClassSearch.Repo.Migrations.CreateLocation do
  use Ecto.Migration

  def change do
    create table(:locations) do
      add :location, :string
      add :room_number, :string
      add :building, :string

      timestamps
    end

  end
end
