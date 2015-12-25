defmodule ClassSearch.ProfessorTest do
  use ClassSearch.ModelCase

  alias ClassSearch.Professor

  @valid_attrs %{first_name: "some content", full_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Professor.changeset(%Professor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Professor.changeset(%Professor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
