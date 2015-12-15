defmodule ClassSearch.DepartmentControllerTest do
  use ClassSearch.ConnCase

  alias ClassSearch.Department
  @valid_attrs %{name: "some content", tag: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, department_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    department = Repo.insert! %Department{}
    conn = get conn, department_path(conn, :show, department)
    assert json_response(conn, 200)["data"] == %{"id" => department.id,
      "name" => department.name,
      "tag" => department.tag}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, department_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, department_path(conn, :create), department: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Department, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, department_path(conn, :create), department: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    department = Repo.insert! %Department{}
    conn = put conn, department_path(conn, :update, department), department: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Department, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    department = Repo.insert! %Department{}
    conn = put conn, department_path(conn, :update, department), department: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    department = Repo.insert! %Department{}
    conn = delete conn, department_path(conn, :delete, department)
    assert response(conn, 204)
    refute Repo.get(Department, department.id)
  end
end
