defmodule Ring do
  @interval 2_000
  @leader :leader

  def start do
    listener = spawn(__MODULE__, :listen, [[], nil])

    case :global.whereis_name(@leader) do
      # when there is no lead yet
      :undefined ->
        :global.register_name(@leader, listener)
        send(listener, {:init, [listener], listener})

      leader when is_pid(leader) ->
        send(leader, {:register, listener})
    end
  end

  def listen(listeners, next) do
    receive do
      {:init, listeners, next} ->
        listen(listeners, next)

      {:register, listener} ->
        listen(listeners ++ [listener], next)

      {:tick, listeners, last_leader} ->
        me = self()
        IO.puts("tock from #{inspect(me)}")

        # find next from listeners
        next = next_from_list(listeners, me)
        :global.re_register_name(@leader, me)

        if last_leader != me do
          send(last_leader, {:complete})
        end

        listen(listeners, next)

      {:complete} ->
        listen([], nil)
    after
      @interval ->
        if next != nil do
          IO.puts("tick from #{inspect(self())}")
          send(next, {:tick, listeners, self()})
        end

        listen(listeners, next)
    end
  end

  defp next_from_list(list, item) do
    index = Enum.find_index(list, &(&1 == item))
    if index == length(list) - 1, do: Enum.at(list, 0), else: Enum.at(list, index + 1)
  end
end
