defmodule ClassSearch.Timeslot do
  use ClassSearch.Web, :model

  schema "timeslots" do
    field :start_time, Ecto.Time
    field :end_time, Ecto.Time
    field :days_of_week, :string

    timestamps
  end

  @required_fields ~w(start_time end_time days_of_week)
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
