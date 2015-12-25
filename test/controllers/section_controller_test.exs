defmodule ClassSearch.SectionControllerTest do
  use ClassSearch.ConnCase

  alias ClassSearch.Section
  @valid_attrs %{books_link: "some content", crn: "some content", max_seats: 42, open_seats: 42, section_number: 42}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, section_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = get conn, section_path(conn, :show, section)
    assert json_response(conn, 200)["data"] == %{"id" => section.id,
      "section_number" => section.section_number,
      "crn" => section.crn,
      "open_seats" => section.open_seats,
      "max_seats" => section.max_seats,
      "term_id" => section.term_id,
      "course_id" => section.course_id,
      "books_link" => section.books_link}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, section_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, section_path(conn, :create), section: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Section, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, section_path(conn, :create), section: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = put conn, section_path(conn, :update, section), section: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Section, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = put conn, section_path(conn, :update, section), section: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    section = Repo.insert! %Section{}
    conn = delete conn, section_path(conn, :delete, section)
    assert response(conn, 204)
    refute Repo.get(Section, section.id)
  end
end
