defmodule ClassSearch.TimeslotControllerTest do
  use ClassSearch.ConnCase

  alias ClassSearch.Timeslot
  @valid_attrs %{days_of_week: "some content", end_time: "14:00:00", start_time: "14:00:00"}
  @invalid_attrs %{}

  setup do
    conn = conn() |> put_req_header("accept", "application/json")
    {:ok, conn: conn}
  end

  test "lists all entries on index", %{conn: conn} do
    conn = get conn, timeslot_path(conn, :index)
    assert json_response(conn, 200)["data"] == []
  end

  test "shows chosen resource", %{conn: conn} do
    timeslot = Repo.insert! %Timeslot{}
    conn = get conn, timeslot_path(conn, :show, timeslot)
    assert json_response(conn, 200)["data"] == %{"id" => timeslot.id,
      "start_time" => timeslot.start_time,
      "end_time" => timeslot.end_time,
      "days_of_week" => timeslot.days_of_week}
  end

  test "does not show resource and instead throw error when id is nonexistent", %{conn: conn} do
    assert_raise Ecto.NoResultsError, fn ->
      get conn, timeslot_path(conn, :show, -1)
    end
  end

  test "creates and renders resource when data is valid", %{conn: conn} do
    conn = post conn, timeslot_path(conn, :create), timeslot: @valid_attrs
    assert json_response(conn, 201)["data"]["id"]
    assert Repo.get_by(Timeslot, @valid_attrs)
  end

  test "does not create resource and renders errors when data is invalid", %{conn: conn} do
    conn = post conn, timeslot_path(conn, :create), timeslot: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "updates and renders chosen resource when data is valid", %{conn: conn} do
    timeslot = Repo.insert! %Timeslot{}
    conn = put conn, timeslot_path(conn, :update, timeslot), timeslot: @valid_attrs
    assert json_response(conn, 200)["data"]["id"]
    assert Repo.get_by(Timeslot, @valid_attrs)
  end

  test "does not update chosen resource and renders errors when data is invalid", %{conn: conn} do
    timeslot = Repo.insert! %Timeslot{}
    conn = put conn, timeslot_path(conn, :update, timeslot), timeslot: @invalid_attrs
    assert json_response(conn, 422)["errors"] != %{}
  end

  test "deletes chosen resource", %{conn: conn} do
    timeslot = Repo.insert! %Timeslot{}
    conn = delete conn, timeslot_path(conn, :delete, timeslot)
    assert response(conn, 204)
    refute Repo.get(Timeslot, timeslot.id)
  end
end
