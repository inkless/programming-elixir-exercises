defmodule WordCounter do
  def count(scheduler) do
    send(scheduler, {:ready, self()})

    receive do
      {:count, job = {file_name, word}, client} ->
        count = read_and_count(file_name, word)
        # IO.puts "count: #{count}"
        send(client, {:answer, job, count, self()})
        count(scheduler)

      {:shutdown} ->
        exit(:normal)
    end
  end

  defp read_and_count(file_name, word) do
    File.read!(file_name)
    |> String.split(word)
    |> length()
    |> Kernel.-(1)
  end
end

defmodule Scheduler do
  def run(num_processes, module, func, to_process) do
    1..num_processes
    |> Enum.map(fn _ -> spawn(module, func, [self()]) end)
    |> schedule_processes(to_process, [])
  end

  defp schedule_processes(processes, queue, results) do
    # IO.puts "schedule_processes before #{inspect processes}, queue #{inspect queue, charlists: :as_lists}"
    receive do
      {:ready, pid} when queue != [] ->
        [next | tail] = queue
        # IO.puts "in schedule_processes#receive ready #{inspect pid}, next: #{inspect next}"
        send(pid, {:count, next, self()})
        schedule_processes(processes, tail, results)

      {:ready, pid} ->
        send(pid, {:shutdown})

        if length(processes) > 1 do
          schedule_processes(List.delete(processes, pid), queue, results)
        else
          results
          #   Enum.sort(results, fn {n1, _}, {n2, _} -> n1 <= n2 end)
        end

      {:answer, id, result, _pid} ->
        # IO.puts "anwser #{inspect id}, result: #{inspect result}, results: #{inspect [{id, result} | results]}"
        schedule_processes(processes, queue, [{id, result} | results])
    end
  end
end

get_word = fn
  [word | _tail] -> word
  _ -> "def"
end

word =
  System.argv()
  |> get_word.()

IO.puts("Counting word #{word}...\n-------------")

to_process =
  File.ls!()
  |> Enum.map(fn file_name -> {file_name, word} end)

Enum.each(1..10, fn num_processes ->
  # IO.puts "num_processes #{num_processes}"
  {time, result} =
    :timer.tc(
      Scheduler,
      :run,
      [num_processes, WordCounter, :count, to_process]
    )

  if num_processes == 1 do
    IO.puts("Count     File Name    Word")
    result
    |> Enum.map(fn {{file_name, word}, count} -> "#{count}         #{file_name} #{word}" end)
    |> Enum.join("\n")
    |> IO.puts
    IO.puts "--------------\n"
  end

  :io.format("~2B   ~.2f~n", [num_processes, time / 1_000_000.0])
end)
