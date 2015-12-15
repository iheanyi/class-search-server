defmodule ClassSearch.Router do
  use ClassSearch.Web, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json-api"]
    plug ClassSearch.DeserializePlug
  end

  scope "/", ClassSearch do
    pipe_through :api

    resources "/terms", TermController
    resources "/departments", DepartmentController
  end
end
