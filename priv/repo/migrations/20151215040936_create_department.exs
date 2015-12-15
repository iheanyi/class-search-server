defmodule ClassSearch.Repo.Migrations.CreateDepartment do
  use Ecto.Migration

  def change do
    create table(:departments, primary_key: false) do
      add :name, :string
      add :tag, :string, primary_key: true

      timestamps
    end

  end
end
