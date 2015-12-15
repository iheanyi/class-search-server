defmodule Management do
  # Module responsible for data management.
  alias ClassSearch.Repo
  alias ClassSearch.Term
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
  

end
