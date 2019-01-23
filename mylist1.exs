defmodule MyList do
  def len([]), do: 0

  def len([_head | tail]) do
    1 + len(tail)
  end

  def square([]), do: []

  def square([head | tail]) do
    [head * head | square(tail)]
  end

  def add_1([]), do: []

  def add_1([head | tail]) do
    [head + 1 | add_1(tail)]
  end

  def map([], _func), do: []

  def map([head | tail], func) do
    [func.(head) | map(tail, func)]
  end

  def sum([v]), do: v

  def sum([head | tail]) when is_list(tail) and length(tail) >= 1 do
    head + sum(tail)
  end

  def reduce(list, func, value \\ 0)
  def reduce([], func, value) when is_function(func), do: value

  def reduce([head | tail], func, value) when is_function(func) do
    reduce(tail, func, func.(value, head))
  end

  def mapsum(list, func) do
    sum(map(list, func))
  end

  def max([a]), do: a
  def max([a, b]) when a === b, do: a
  def max([a, b]) when a > b, do: a
  def max([a, b]) when a < b, do: b

  def max([head | tail]) when is_list(tail) and length(tail) >= 2 do
    max([head, max(tail)])
  end

  def caesar([], _n), do: []
  def caesar([head | tail], n) when head + n <= ?z  do
    [head + n | caesar(tail, n)]
  end
  def caesar([head | tail], n)  do
    [head + n - 26 | caesar(tail, n)]
  end

  def caesar2(list, n) do
    list
    |> Enum.map(&(&1 + rem(n, 26)))
    |> Enum.map(&_wrap_char/1)
  end

  def span(from, to) when is_number(from) and is_number(to) and from == to do
    [from]
  end

  def span(from, to) when is_number(from) and is_number(to) and from < to do
    [from | span(from + 1, to)]
  end

  defp _wrap_char(char) when char > ?z, do: char - 26
  defp _wrap_char(char), do: char
end
