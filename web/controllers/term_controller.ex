defmodule ClassSearch.TermController do
  use ClassSearch.Web, :controller

  alias ClassSearch.Term

  plug :scrub_params, "term" when action in [:create, :update]

  def index(conn, _params) do
    terms = Repo.all(Term)
    render(conn, "index.json", terms: terms)
  end

  def create(conn, %{"term" => term_params}) do
    changeset = Term.changeset(%Term{}, term_params)

    case Repo.insert(changeset) do
      {:ok, term} ->
        conn
        |> put_status(:created)
        |> put_resp_header("location", term_path(conn, :show, term))
        |> render("show.json", term: term)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def show(conn, %{"id" => id}) do
    term = Repo.get!(Term, id)
    render(conn, "show.json", term: term)
  end

  def update(conn, %{"id" => id, "term" => term_params}) do
    term = Repo.get!(Term, id)
    changeset = Term.changeset(term, term_params)

    case Repo.update(changeset) do
      {:ok, term} ->
        render(conn, "show.json", term: term)
      {:error, changeset} ->
        conn
        |> put_status(:unprocessable_entity)
        |> render(ClassSearch.ChangesetView, "error.json", changeset: changeset)
    end
  end

  def delete(conn, %{"id" => id}) do
    term = Repo.get!(Term, id)

    # Here we use delete! (with a bang) because we expect
    # it to always work (and if it does not, it will raise).
    Repo.delete!(term)

    send_resp(conn, :no_content, "")
  end
end
