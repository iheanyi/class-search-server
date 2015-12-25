defmodule ClassSearch.SectionProfessorTest do
  use ClassSearch.ModelCase

  alias ClassSearch.SectionProfessor

  @valid_attrs %{}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SectionProfessor.changeset(%SectionProfessor{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SectionProfessor.changeset(%SectionProfessor{}, @invalid_attrs)
    refute changeset.valid?
  end
end
