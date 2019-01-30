defmodule Stack.Stash do
  use Agent

  def start_link(init_stack) do
    Agent.start_link(fn -> init_stack end, name: __MODULE__)
  end

  def value do
    Agent.get(__MODULE__, & &1)
  end

  def update(update_stack) do
    Agent.update(__MODULE__, fn _ -> update_stack end)
  end
end
