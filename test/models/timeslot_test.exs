defmodule ClassSearch.TimeslotTest do
  use ClassSearch.ModelCase

  alias ClassSearch.Timeslot

  @valid_attrs %{days_of_week: "some content", end_time: "14:00:00", start_time: "14:00:00"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Timeslot.changeset(%Timeslot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Timeslot.changeset(%Timeslot{}, @invalid_attrs)
    refute changeset.valid?
  end
end
