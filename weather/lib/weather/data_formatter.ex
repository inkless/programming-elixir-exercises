defmodule Weather.DataFormatter do
  @moduledoc """
  Documentation for Weather.
  """

  # ~S to not escapte \n
  @doc ~S"""
  format weather information given a map

  ## Examples

      iex> map = %{
      ...> name: "SFO",
      ...> time: "Jan 01 2018",
      ...> weather: "Cloudy",
      ...> temperature: "48.0 F (8.9 C)",
      ...> wind: "Southeast at 11.5 MPH (10 KT)"
      ...> }
      iex> Weather.DataFormatter.format(map)
      "SFO\n---\nTime: Jan 01 2018\nWeather: Cloudy\nTemperature: 48.0 F (8.9 C)\nWind: Southeast at 11.5 MPH (10 KT)"

  """
  def format(map) do
    [get_title(map.name) | get_content(map)]
    |> Enum.join("\n")
  end

  defp get_content(map) do
    [:time, :weather, :temperature, :wind]
    |> Enum.map(fn key ->
      String.capitalize(to_string(key)) <> ": " <> map[key]
    end)
  end

  defp get_title(name) do
    name <> "\n" <> String.duplicate("-", String.length(name))
  end
end
