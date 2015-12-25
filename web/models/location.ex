defmodule ClassSearch.Location do
  use ClassSearch.Web, :model

  schema "locations" do
    field :location, :string
    field :room_number, :string
    field :building, :string

    timestamps
  end

  @required_fields ~w(location room_number building)
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
