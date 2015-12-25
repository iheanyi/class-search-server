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
    plug JaSerializer.Deserializer
  end

  scope "/", ClassSearch do
    pipe_through :api

    resources "/terms", TermController do 
      resources "/departments", DepartmentController
      resources "/courses", CourseController
      resources "/timeslots", TimeslotController
    end

    resources "/departments", DepartmentController
    resources "/courses", CourseController
    resources "/professors", ProfessorController
    resources "/timeslots", TimeslotController
    resources "/sections", SectionController
    resources "/locations", LocationController
  end
end
