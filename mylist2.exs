defmodule MyList do
  def all?([], _func), do: true
  def all?([head | tail], func) do
    func.(head) && all?(tail, func)
  end

  def each([], _func), do: :ok
  def each([head | tail], func) do
    func.(head)
    each(tail, func)
  end

  def filter([], _func), do: []
  def filter([head | tail], func) do
    if func.(head) do
      [head | filter(tail, func)]
    else
      filter(tail, func)
    end
  end

  def split(list, count) when count <= -length(list), do: {[], list}
  def split(list, count) when count < 0, do: split(list, length(list) + count)
  def split(list, count) when count >= 0 do
    _split({[], list}, count)
  end

  defp _split({pre, []}, _count) do
    {pre, []}
  end
  defp _split({pre, post}, count) when length(pre) === count or length(post) === 0 do
    {pre, post}
  end

  defp _split({pre, [head | tail]}, count) when length(pre) < count do
    _split({pre ++ [head], tail}, count)
  end

  def take([], _count), do: []
  def take(_list, 0), do: []

  # for count > 0
  def take([head | tail], count) when count > 0 do
    [head | take(tail, count - 1)]
  end

  # for count < 0
  def take(list, count) when count < -length(list), do: list
  def take(list, count) when count < 0, do: _take(list, count + length(list))
  defp _take(list, 0), do: list
  defp _take([_head | tail], count), do: _take(tail, count - 1)

  def reverse([]), do: []
  def reverse([head | tail]) do
    reverse(tail) ++ [head]
  end

  def flatten([]), do: []
  def flatten([head | tail]) when is_list(head) do
    flatten(head) ++ flatten(tail)
  end
  def flatten([head | tail]) do
    [head | flatten(tail)]
  end

  def flatten2(list) when is_list(list) do
    _flatten(list, [])
  end

  def _flatten([], acc), do: acc
  def _flatten([head | tail], acc) do
    _flatten(head, _flatten(tail, acc))
  end
  def _flatten(head, acc), do: [head | acc]

end
