defmodule Management do
  # Module responsible for data management.
  
  def import_terms do
    terms = Scraper.fetch_terms
    terms
  end
  

end
