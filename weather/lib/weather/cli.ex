defmodule Weather.CLI do
  @moduledoc """
  Documentation for Weather.CLI
  """

  def main([location | _tail]) do
    Weather.check(location)
  end

end
