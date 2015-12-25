defmodule ClassSearch.ProfessorControllerTest do
  use ClassSearch.ConnCase

  alias ClassSearch.Professor
  @valid_attrs %{first_name: "some content", full_name: "some content", last_name: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, professor_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    professor = Repo.insert! %Professor{}
    conn = get conn, professor_path(conn, :show, professor)
    assert json_response(conn, 200)["data"] == %{"id" => professor.id,
      "first_name" => professor.first_name,
      "last_name" => professor.last_name,
      "full_name" => professor.full_name}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, professor_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, professor_path(conn, :create), professor: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Professor, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, professor_path(conn, :create), professor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    professor = Repo.insert! %Professor{}
    conn = put conn, professor_path(conn, :update, professor), professor: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Professor, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    professor = Repo.insert! %Professor{}
    conn = put conn, professor_path(conn, :update, professor), professor: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    professor = Repo.insert! %Professor{}
    conn = delete conn, professor_path(conn, :delete, professor)
    assert response(conn, 204)
    refute Repo.get(Professor, professor.id)
  end
end
