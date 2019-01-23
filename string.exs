defmodule MyString do
  def is_printable(str) when is_list(str) do
    Enum.all?(str, &(&1 >= ?\s && &1 <= ?~))
  end

  def anagram?(word1, word2) do
    Enum.sort(word1) == Enum.sort(word2)
  end

  def calculate(str) do
    [num1, op, num2] = str |> to_string |> String.split(" ")
    _applyCalculate(String.to_integer(num1), op, String.to_integer(num2))
  end

  defp _applyCalculate(num1, "+", num2), do: num1 + num2
  defp _applyCalculate(num1, "-", num2), do: num1 - num2
  defp _applyCalculate(num1, "*", num2), do: num1 * num2
  defp _applyCalculate(num1, "/", num2), do: num1 / num2

  def center(list) do
    max = String.length(Enum.max_by(list, &String.length/1))

    for word <- list do
      len = String.length(word)
      pad_left = div(max - len, 2) + len

      word
      |> String.pad_leading(pad_left, " ")
      |> String.pad_trailing(max, " ")
      |> IO.puts()
    end
  end

  def capitalize_sentences(str) when is_bitstring(str) do
    str
    |> String.split(". ")
    |> Enum.map(&String.capitalize/1)
    |> Enum.join(". ")
  end
end

defmodule Utf8 do
  def each(str, func) when is_bitstring(str) do
    _each(str, func)
  end

  defp _each(<<>>, _func), do: :ok

  defp _each(<<head::utf8, tail::binary>>, func) do
    func.(head)
    _each(tail, func)
  end

  def each2(str, func) do
    str |> to_charlist |> Enum.each(func)
  end
end

defmodule StringCalculatorCheater do
  def calculate(str), do: _calculate(str, 0)

  defp _calculate([], value), do: value
  defp _calculate([?\s | tail], value), do: _calculate(tail, value)

  defp _calculate([digit | tail], value)
       when digit in '0123456789',
       do: _calculate(tail, value * 10 + digit - ?0)

  defp _calculate([operator | tail], value)
       when operator in '+-*/',
       do: apply(Kernel, List.to_atom([operator]), [value, calculate(tail)])
end
