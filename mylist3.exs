defmodule MyList do
  @tax_rates [NC: 0.075, TX: 0.08]
  def span(from, to) when from == to, do: [from]
  def span(from, to) when from < to, do: [from | span(from + 1, to)]

  def primes(n) when n >= 2 do
    for x <- span(2, n), is_prime(x), do: x
  end

  defp is_prime(n) when n == 2 or n == 3, do: true

  defp is_prime(n) when is_number(n) and n > 3 do
    Enum.all?(span(2, trunc(:math.sqrt(n))), &(rem(n, &1) != 0))
  end

  def add_tax(orders, tax_rates) do
    for order = [_, ship_to: ship_to, net_amount: net_amount] <- orders do
      total_amount = net_amount * (1 + Keyword.get(tax_rates, ship_to, 0))
      order ++ [total_amount: total_amount]
    end
  end

  def tax(file_name \\ "sales.csv") do
    file = File.open!(file_name)
    names = file |> IO.read(:line) |> line_to_list() |> Enum.map(&String.to_atom/1)

    orders =
      file
      |> IO.stream(:line)
      |> Enum.map(fn line ->
        Enum.zip(
          names,
          line |> line_to_list |> format_line
        )
      end)

    add_tax orders, @tax_rates
  end

  defp format_line(list) do
    [id, ship_to, net_amount] = list

    [
      String.to_integer(id),
      ship_to |> String.trim_leading(":") |> String.to_atom(),
      String.to_float(net_amount)
    ]
  end

  defp line_to_list(line) do
    line |> String.trim_trailing() |> String.split(",")
  end
end
