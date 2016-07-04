defmodule Scraper.Utils do
  @doc """
  Filters out binary strings from the array and returns the array of the cleaned
  strings.
  """
  def filter_binary_and_strip(arr) do
    values = Enum.filter_map(arr, fn x -> (is_binary x) end, fn item ->
      item
      |> String.strip
      |> clean_num_string 
      
      #String.strip(item) # Clean out the whitespace.
    end) 
  end

  @doc """
  Clean out the numbers (i.e '(1)', '(2)') from a string.
  """
  def clean_num_string(str) do 
    Regex.replace(~r/\(\d+\)\ /, str, "")
  end

end
