defmodule ClassSearch.TimeslotController do
  use ClassSearch.Web, :controller

  alias ClassSearch.Timeslot

  plug :scrub_params, "timeslot" when action in [:create, :update]

  def index(conn, _params) do
    timeslots = Repo.all(Timeslot)
    render(conn, "index.json", timeslots: timeslots)
  end

  def create(conn, %{"timeslot" => timeslot_params}) do
    changeset = Timeslot.changeset(%Timeslot{}, timeslot_params)

    case Repo.insert(changeset) do
      {:ok, timeslot} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", timeslot_path(conn, :show, timeslot))
        |> render("show.json", timeslot: timeslot)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    timeslot = Repo.get!(Timeslot, id)
    render(conn, "show.json", timeslot: timeslot)
  end

  def update(conn, %{"id" => id, "timeslot" => timeslot_params}) do
    timeslot = Repo.get!(Timeslot, id)
    changeset = Timeslot.changeset(timeslot, timeslot_params)

    case Repo.update(changeset) do
      {:ok, timeslot} ->
        render(conn, "show.json", timeslot: timeslot)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    timeslot = Repo.get!(Timeslot, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(timeslot)

    send_resp(conn, :no_content, "")
  end
end
