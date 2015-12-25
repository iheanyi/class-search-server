defmodule ClassSearch.TimeslotView do
  use ClassSearch.Web, :view

  def render("index.json", %{timeslots: timeslots}) do
    %{data: render_many(timeslots, ClassSearch.TimeslotView, "timeslot.json")}
  end

  def render("show.json", %{timeslot: timeslot}) do
    %{data: render_one(timeslot, ClassSearch.TimeslotView, "timeslot.json")}
  end

  def render("timeslot.json", %{timeslot: timeslot}) do
    %{id: timeslot.id,
      start_time: timeslot.start_time,
      end_time: timeslot.end_time,
      days_of_week: timeslot.days_of_week}
  end
end
