defmodule Parse do
  def number([ ?- | tail ]), do: _number_digits(tail) * -1
  def number([ ?+ | tail ]), do: _number_digits(tail)
  def number(str), do: _number_digits(str)

  # '1' -> head
  # '12' -> head * 10 + _number_digits('2')
  # '123' -> head * 100 + _number_digits('23')
  defp _number_digits([]), do: 0
  defp _number_digits(list) do
    Enum.reduce list, 0, fn(digit, acc) ->
      acc * 10 + digit - ?0
    end
  end
  # defp _number_digits([head | tail]) when head in '0123456789' do
  #   digits = tail |> length() |> (&(:math.pow(10, &1))).() |> trunc
  #   (head - ?0) * digits + _number_digits(tail)
  # end
  # defp _number_digits([non_digit | _]) do
  #   raise "Invalid digit '#{non_digit}'"
  # end
end
