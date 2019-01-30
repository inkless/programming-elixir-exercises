defmodule Stack.Server do
  use GenServer

  def start_link(_) do
    GenServer.start_link(__MODULE__, nil, name: __MODULE__)
  end

  def pop do
    GenServer.call(__MODULE__, :pop)
  end

  def push(item) do
    GenServer.cast(__MODULE__, {:push, item})
  end

  def status do
    :sys.get_state(__MODULE__)
  end

  def terminate(reason, state) do
    Stack.Stash.update(state)
  end

  def init(_) do
    {:ok, Stack.Stash.value()}
  end

  def handle_call(:pop, _from, [head | tail]) do
    {:reply, head, tail}
  end

  def handle_cast({:push, item}, list) do
    if is_integer(item) and item < 0 do
      {:stop, :negative, list}
    else
      {:noreply, [item | list]}
    end
  end
end
