defmodule ClassSearch.Term do
  use ClassSearch.Web, :model

  @primary_key {:tag, :integer, []}
  @derive {Phoenix.Param, key: :tag}
  schema "terms" do
    field :name, :string

    timestamps
  end

  @required_fields ~w(name tag)
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
