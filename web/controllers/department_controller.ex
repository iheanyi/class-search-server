defmodule ClassSearch.DepartmentController do
  use ClassSearch.Web, :controller

  alias ClassSearch.Department

  plug :scrub_params, "department" when action in [:create, :update]

  def index(conn, _params) do
    departments = Repo.all(Department)
    render(conn, "index.json", departments: departments)
  end

  def create(conn, %{"department" => department_params}) do
    changeset = Department.changeset(%Department{}, department_params)

    case Repo.insert(changeset) do
      {:ok, department} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", department_path(conn, :show, department))
        |> render("show.json", department: department)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    department = Repo.get!(Department, id)
    render(conn, "show.json", department: department)
  end

  def update(conn, %{"id" => id, "department" => department_params}) do
    department = Repo.get!(Department, id)
    changeset = Department.changeset(department, department_params)

    case Repo.update(changeset) do
      {:ok, department} ->
        render(conn, "show.json", department: department)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    department = Repo.get!(Department, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(department)

    send_resp(conn, :no_content, "")
  end
end
