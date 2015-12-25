defmodule ClassSearch.Professor do
  use ClassSearch.Web, :model

  schema "professors" do
    field :first_name, :string
    field :last_name, :string
    field :full_name, :string
    field :instructor_id, :integer
    
    timestamps
  end

  @required_fields ~w(first_name last_name full_name instructor_id)
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
