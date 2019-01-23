defmodule Weather do
  @moduledoc """
  Documentation for Weather.
  """

  @doc """
  check weather given some code
  """
  def check(location) do
    Weather.DataFetcher.fetch(location)
    |> Weather.DataFormatter.format()
    |> IO.puts()
  end
end
