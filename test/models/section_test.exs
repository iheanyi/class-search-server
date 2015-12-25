defmodule ClassSearch.SectionTest do
  use ClassSearch.ModelCase

  alias ClassSearch.Section

  @valid_attrs %{books_link: "some content", crn: "some content", max_seats: 42, open_seats: 42, section_number: 42}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Section.changeset(%Section{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Section.changeset(%Section{}, @invalid_attrs)
    refute changeset.valid?
  end
end
