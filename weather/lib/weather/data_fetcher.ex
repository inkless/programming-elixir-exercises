defmodule Weather.DataFetcher do
  @url Application.get_env(:weather, :url)

  import SweetXml

  def fetch(location) do
    "#{@url}/#{location}.xml"
    |> HTTPoison.get()
    |> handle_reponse()
    |> parseXML()
  end

  def parseXML(xmldoc) do
    xmldoc
    |> xpath(~x"//current_observation",
      name: ~x"./location/text()"s,
      time: ~x"./observation_time/text()"s,
      weather: ~x"./weather/text()"s,
      temperature: ~x"./temperature_string/text()"s,
      wind: ~x"./wind_string/text()"s
    )
  end

  defp handle_reponse({:ok, %{status_code: 200, body: body}}), do: body
  defp handle_reponse({:ok, %{status_code: 404}}), do: handle_reponse({:error, "Not Found"})
  defp handle_reponse({:ok, %{status_code: code}}), do: handle_reponse({:error, "Bad status code #{code}"})
  defp handle_reponse({:error, error}) do
    IO.puts error
    System.halt(2)
  end
end
