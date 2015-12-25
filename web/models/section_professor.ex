defmodule ClassSearch.SectionProfessor do
  use ClassSearch.Web, :model

  schema "section_professors" do
    belongs_to :professor, ClassSearch.Professor
    belongs_to :section, ClassSearch.Section, references: :crn, type: :string

    timestamps
  end

  @required_fields ~w()
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
