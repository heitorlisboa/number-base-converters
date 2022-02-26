defmodule Utilities do
  @doc """
  Transform a string into a list of single digit strings
  """
  @spec string_to_list(String.t()) :: list(String.t())
  def string_to_list(string) do
    String.split(string, "")
    |> then(fn list -> list -- ["", ""] end)
  end

  @doc """
  Receive a list and return it as a list of tuples. The first item of the tuple
  is the proper item of that index, and the second item is its index
  """
  @spec add_index_for_each_item(list(any())) :: list({any(), integer()})
  def add_index_for_each_item(list) do
    for index <- 0..(length(list) - 1) do
      {Enum.at(list, index), index}
    end
  end
end
