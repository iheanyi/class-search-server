defmodule ClassSearch.LocationTest do
  use ClassSearch.ModelCase

  alias ClassSearch.Location

  @valid_attrs %{building: "some content", location: "some content", room_number: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Location.changeset(%Location{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Location.changeset(%Location{}, @invalid_attrs)
    refute changeset.valid?
  end
end
