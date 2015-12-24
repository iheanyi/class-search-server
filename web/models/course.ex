defmodule ClassSearch.Course do
  use ClassSearch.Web, :model

  schema "courses" do
    field :name, :string
    field :course_number, :string
    belongs_to :department, ClassSearch.Department, references: :tag, type:
    :string

    timestamps
  end

  @required_fields ~w(name course_number department_id)
  @optional_fields ~w()

  @doc """
  Creates a changeset based on the `model` and `params`.

  If no params are provided, an invalid changeset is returned
  with no validation performed.
  """
  def changeset(model, params \\ :empty) do
    model
    |> cast(params, @required_fields, @optional_fields)
    |> unique_constraint(:name, name: :courses_name_course_number_index)
  end
end
