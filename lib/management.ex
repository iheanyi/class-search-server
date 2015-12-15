defmodule Management do
  # Module responsible for data management.
  alias ClassSearch.Repo
  alias ClassSearch.Term
  alias ClassSearch.Department
  
  def import_terms do
    terms = Scraper.fetch_terms
    |> Enum.map(fn term -> 
      data = %{name: term.name, tag: term.value}
      changeset = Term.changeset(%Term{}, data)
      old_term = Repo.get(Term, term.value)
      if is_nil old_term do
        case Repo.insert(changeset) do 
          {:ok, _term} ->
            IO.puts "Successfully inserted Term (#{data.tag} - #{data.name})"
          {:error, changeset} ->
            IO.puts "Error inserting Term (#{data.tag} - #{data.name})"
        end
      end
    end
    )
    terms
  end
  
  def import_departments do
    # Import departments from the parser.
    departments = Scraper.fetch_departments
    |> Enum.map(fn dept ->
      name = String.strip(dept.name)
      value = String.strip(dept.value)
      data = %{name: name, tag: value}
      changeset = Department.changeset(%Department{}, data)
      old_dept = Repo.get(Department, dept.value)

      if is_nil old_dept do
        
        case Repo.insert(changeset) do
          {:ok, _dept} ->
            IO.puts "Successfully inserted #{data.tag} department"
          {:error, changeset} ->
            IO.puts "Error inserting Department #{data.tag} - #{data.name}"
        end
      end
    end)
    departments
  end

end
