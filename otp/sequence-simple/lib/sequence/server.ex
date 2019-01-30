defmodule Sequence.Server do
  use GenServer

  def start_link(init_number) do
    IO.inspect __MODULE__
    GenServer.start_link __MODULE__, init_number, name: __MODULE__
  end

  def next_number do
    GenServer.call __MODULE__, :next_number
  end

  def increase_number(delta) do
    GenServer.cast __MODULE__, {:increase_number, delta}
  end

  def status do
    :sys.get_status __MODULE__
  end

  def init(init_number) do
    {:ok, init_number}
  end

  def handle_call(:next_number, _from, current_number) do
    {:reply, current_number, current_number + 1}
  end

  def handle_cast({:increase_number, delta}, current_number) do
    {:noreply, current_number + delta}
  end

  def format_status(_reason, [_pdict, state]) do
    [data: [{'State', "My current state is '#{inspect(state)}', and I'm happy"}]]
  end
end
