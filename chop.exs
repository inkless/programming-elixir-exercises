defmodule Chop do
  def guess(actual, min..max) when actual < min or actual > max do
    IO.puts("Not possible")
  end

  def guess(actual, min..max) do
    attempt = div(min + max, 2)
    IO.puts("Is it #{attempt}, testing between #{inspect(min..max)}")
    _guess(actual, min..max, attempt)
  end

  defp _guess(actual, _, attempt) when actual === attempt do
    attempt
  end

  defp _guess(actual, min.._, attempt) when actual < attempt do
    guess(actual, min..(attempt - 1))
  end

  defp _guess(actual, _..max, attempt) when actual > attempt do
    guess(actual, (attempt + 1)..max)
  end
end
