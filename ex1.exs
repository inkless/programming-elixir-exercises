fun1 = fn
  0, 0, _ -> "FizzBuzz"
  0, _, _ -> "Fizz"
  _, 0, _ -> "Buzz"
  _, _, a -> a
end

# IO.puts fun1.(0, 0, "a")
# IO.puts fun1.(0, 1, "a")
# IO.puts fun1.(1, 0, "a")
# IO.puts fun1.(1, 1, "a")

fizz_buz = fn n ->
  fun1.(rem(n, 3), rem(n, 5), n)
end

fun2 = fn ->
  fn ->
    IO.puts("hello")
  end
end


Enum.each(
  [10, 11, 12, 13, 14, 15, 16],
  &(IO.puts fizz_buz.(&1))
)
