defmodule DefaultP do
  def func(p1, p2 \\ 123)

  def func(p1, 99) do
    IO.puts "yo 99"
  end

  def func(p1, p2) when p2 !== 99 do
    IO.inspect [p1, p2]
  end
end
