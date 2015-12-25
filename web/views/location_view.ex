defmodule ClassSearch.LocationView do
  use ClassSearch.Web, :view

  def render("index.json", %{locations: locations}) do
    %{data: render_many(locations, ClassSearch.LocationView, "location.json")}
  end

  def render("show.json", %{location: location}) do
    %{data: render_one(location, ClassSearch.LocationView, "location.json")}
  end

  def render("location.json", %{location: location}) do
    %{id: location.id,
      location: location.location,
      room_number: location.room_number,
      building: location.building}
  end
end
