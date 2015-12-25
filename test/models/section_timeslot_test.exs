defmodule ClassSearch.SectionTimeslotTest do
  use ClassSearch.ModelCase

  alias ClassSearch.SectionTimeslot

  @valid_attrs %{begin_date: "2010-04-17", end_date: "2010-04-17"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = SectionTimeslot.changeset(%SectionTimeslot{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = SectionTimeslot.changeset(%SectionTimeslot{}, @invalid_attrs)
    refute changeset.valid?
  end
end
