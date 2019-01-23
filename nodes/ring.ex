defmodule Ring do
  @interval 2_000
  @leader :leader

  def start do
    leader = spawn(__MODULE__, :lead, [[], nil])
    follower = spawn(__MODULE__, :follow, [leader])

    case :global.whereis_name(@leader) do
      # when there is no lead yet
      :undefined ->
        :global.register_name(@leader, leader)
        send(leader, {:init, [follower], follower})

      leader when is_pid(leader) ->
        send(leader, {:register, follower})
    end
  end

  def lead(rings, next) do
    receive do
      {:init, rings, next} ->
        # IO.puts(
        #   "on init rings #{inspect(rings)} next #{inspect(next)}"
        # )
        lead(rings, next)

      {:register, follower} ->
        lead(rings ++ [follower], next)

      {:complete} ->
        lead([], nil)
    after
      @interval ->
        # IO.puts(
        #   "after interval  rings #{inspect(rings)} next #{inspect(next)}"
        # )
        if next != nil do
          IO.puts("tick from leader #{inspect(self())}")
          send(next, {:tick, rings, self()})
        end

        lead(rings, next)
    end
  end

  def follow(leader) do
    receive do
      {:tick, rings, last_leader} ->
        IO.puts("tock in client #{inspect(self())}")

        # find next from rings
        next = next_from_list(rings, self())
        # IO.puts(
        #   "send leader #{inspect(leader)} with rings #{inspect(rings)} next #{inspect(next)}"
        # )

        :global.re_register_name(@leader, leader)
        send(last_leader, {:complete})
        send(leader, {:init, rings, next})

        follow(leader)
    end
  end

  defp next_from_list(list, item) do
    index = Enum.find_index(list, &(&1 == item))
    if index == length(list) - 1, do: Enum.at(list, 0), else: Enum.at(list, index + 1)
  end
end
