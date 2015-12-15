defmodule ClassSearch.Repo.Migrations.CreateTerm do
  use Ecto.Migration

  def change do
    create table(:terms, primary_key: false) do
      add :name, :string
      add :tag, :integer, primary_key: true

      timestamps
    end

  end
end
