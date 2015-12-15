defmodule ClassSearch.DepartmentTest do
  use ClassSearch.ModelCase

  alias ClassSearch.Department

  @valid_attrs %{name: "some content", tag: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Department.changeset(%Department{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Department.changeset(%Department{}, @invalid_attrs)
    refute changeset.valid?
  end
end
