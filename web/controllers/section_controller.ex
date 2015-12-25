defmodule ClassSearch.SectionController do
  use ClassSearch.Web, :controller

  alias ClassSearch.Section

  plug :scrub_params, "section" when action in [:create, :update]

  def index(conn, _params) do
    sections = Repo.all(Section)
    render(conn, "index.json", sections: sections)
  end

  def create(conn, %{"section" => section_params}) do
    changeset = Section.changeset(%Section{}, section_params)

    case Repo.insert(changeset) do
      {:ok, section} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", section_path(conn, :show, section))
        |> render("show.json", section: section)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)
    render(conn, "show.json", section: section)
  end

  def update(conn, %{"id" => id, "section" => section_params}) do
    section = Repo.get!(Section, id)
    changeset = Section.changeset(section, section_params)

    case Repo.update(changeset) do
      {:ok, section} ->
        render(conn, "show.json", section: section)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    section = Repo.get!(Section, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(section)

    send_resp(conn, :no_content, "")
  end
end
