defmodule Duper.Worker do
  use GenServer, restart: :transient

  def start_link(_) do
    GenServer.start_link(__MODULE__, :no_args)
  end

  @impl GenServer
  def init(:no_args) do
    Process.send_after(self(), :do_one_file, 0)
    {:ok, nil}
  end

  @impl GenServer
  def handle_info(:do_one_file, _) do
    Duper.PathFinder.next()
    |> add_result()
  end

  defp add_result(nil) do
    Duper.Gatherer.done()
    {:stop, :normal, nil}
  end

  defp add_result(path) do
    Duper.Gatherer.result(path, calc_hash(path))
    send(self(), :do_one_file)
    {:noreply, nil}
  end

  defp calc_hash(path) do
    File.stream!(path, [], 1024 * 1024)
    |> Enum.reduce(:crypto.hash_init(:md5), fn block, acc -> :crypto.hash_update(acc, block) end)
    |> :crypto.hash_final()
  end
end
