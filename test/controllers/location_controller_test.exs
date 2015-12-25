defmodule ClassSearch.LocationControllerTest do
  use ClassSearch.ConnCase

  alias ClassSearch.Location
  @valid_attrs %{building: "some content", location: "some content", room_number: "some content"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, location_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = get conn, location_path(conn, :show, location)
    assert json_response(conn, 200)["data"] == %{"id" => location.id,
      "location" => location.location,
      "room_number" => location.room_number,
      "building" => location.building}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, location_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, location_path(conn, :create), location: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Location, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, location_path(conn, :create), location: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = put conn, location_path(conn, :update, location), location: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Location, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = put conn, location_path(conn, :update, location), location: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    location = Repo.insert! %Location{}
    conn = delete conn, location_path(conn, :delete, location)
    assert response(conn, 204)
    refute Repo.get(Location, location.id)
  end
end
