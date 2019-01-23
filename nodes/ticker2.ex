defmodule Ticker do
  @interval 2_000
  @name :ticker

  def start do
    pid = spawn(__MODULE__, :generator, [[], []])
    :global.register_name(@name, pid)
  end

  def register(client_pid) do
    ticker_pid = :global.whereis_name(@name)
    send(ticker_pid, {:register, client_pid})
  end

  def generator(queue, clients) do
    receive do
      {:register, client_pid} ->
        IO.puts("register #{inspect(client_pid)}")
        generator(queue ++ [client_pid], clients ++ [client_pid])
    after
      @interval ->
        IO.puts("tick")

        queue = if queue == [], do: clients, else: queue

        if queue != [] do
          [client | tail] = queue
          send(client, {:tick})
          generator(tail, clients)
        else
          generator([], clients)
        end
    end
  end
end

defmodule Client do
  def start do
    Ticker.register(spawn(__MODULE__, :receiver, []))
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts("tock in client")
        receiver()
    end
  end
end
