defmodule ClassSearch.Section do
  use ClassSearch.Web, :model

  @primary_key {:crn, :integer, []}
  @derive {Phoenix.Param, key: :crn}
  schema "sections" do
    field :section_number, :integer
    field :open_seats, :integer
    field :max_seats, :integer
    field :books_link, :string
    belongs_to :term, ClassSearch.Term, foreign_key: :tag, type: :integer,
    references: :tag 
    belongs_to :course, ClassSearch.Course, references: :crn

    timestamps
  end

  @required_fields ~w(section_number crn open_seats max_seats books_link)
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
