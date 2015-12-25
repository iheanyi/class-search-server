defmodule ClassSearch.ProfessorController do
  use ClassSearch.Web, :controller

  alias ClassSearch.Professor

  plug :scrub_params, "professor" when action in [:create, :update]

  def index(conn, _params) do
    professors = Repo.all(Professor)
    render(conn, "index.json", professors: professors)
  end

  def create(conn, %{"professor" => professor_params}) do
    changeset = Professor.changeset(%Professor{}, professor_params)

    case Repo.insert(changeset) do
      {:ok, professor} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", professor_path(conn, :show, professor))
        |> render("show.json", professor: professor)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    professor = Repo.get!(Professor, id)
    render(conn, "show.json", professor: professor)
  end

  def update(conn, %{"id" => id, "professor" => professor_params}) do
    professor = Repo.get!(Professor, id)
    changeset = Professor.changeset(professor, professor_params)

    case Repo.update(changeset) do
      {:ok, professor} ->
        render(conn, "show.json", professor: professor)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    professor = Repo.get!(Professor, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(professor)

    send_resp(conn, :no_content, "")
  end
end
