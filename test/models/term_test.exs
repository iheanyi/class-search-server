defmodule ClassSearch.TermTest do
  use ClassSearch.ModelCase

  alias ClassSearch.Term

  @valid_attrs %{name: "some content", tag: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Term.changeset(%Term{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Term.changeset(%Term{}, @invalid_attrs)
    refute changeset.valid?
  end
end
