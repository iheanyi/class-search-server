defmodule ClassSearch.TermControllerTest do
  use ClassSearch.ConnCase

  alias ClassSearch.Term
  @valid_attrs %{name: "some content", tag: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, term_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    term = Repo.insert! %Term{}
    conn = get conn, term_path(conn, :show, term)
    assert json_response(conn, 200)["data"] == %{"id" => term.id,
      "name" => term.name,
      "tag" => term.tag}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, term_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, term_path(conn, :create), term: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Term, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, term_path(conn, :create), term: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    term = Repo.insert! %Term{}
    conn = put conn, term_path(conn, :update, term), term: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Term, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    term = Repo.insert! %Term{}
    conn = put conn, term_path(conn, :update, term), term: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    term = Repo.insert! %Term{}
    conn = delete conn, term_path(conn, :delete, term)
    assert response(conn, 204)
    refute Repo.get(Term, term.id)
  end
end
