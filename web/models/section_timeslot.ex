defmodule ClassSearch.SectionTimeslot do
  use ClassSearch.Web, :model

  schema "section_timeslots" do
    field :begin_date, Ecto.Date
    field :end_date, Ecto.Date
    belongs_to :section, ClassSearch.Section
    belongs_to :timeslot, ClassSearch.Timeslot

    timestamps
  end

  @required_fields ~w(begin_date end_date)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
  end
end
