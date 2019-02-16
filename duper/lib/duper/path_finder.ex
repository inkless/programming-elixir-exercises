defmodule Duper.PathFinder do
  @moduledoc """
  """

  use GenServer

  @me __MODULE__

  # Public

  def start_link(root) do
    GenServer.start_link(@me, root, name: @me)
  end

  def next do
    GenServer.call(@me, :next)
  end

  # Server

  def init(root) do
    # returns {:ok, walker}
    DirWalker.start_link(root)
  end

  def handle_call(:next, _from, walker) do
    path =
      case DirWalker.next(walker) do
        [path] -> path
        other -> other
      end

    {:reply, path, walker}
  end
end
