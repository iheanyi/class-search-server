defmodule ClassSearch.Repo.Migrations.CreateProfessor do
  use Ecto.Migration

  def change do
    create table(:professors) do
      add :first_name, :string
      add :last_name, :string
      add :full_name, :string
      add :instructor_id, :integer

      timestamps
    end

  end
end
