defmodule Ticker do
  @interval 2_000
  @name :ticker

  def start do
    :global.register_name(@name, self())
    generator([])
  end

  def register(client_pid) do
    ticker_pid = :global.whereis_name(@name)
    send(ticker_pid, {:register, client_pid})
  end

  def generator(clients) do
    receive do
      {:register, client_pid} ->
        IO.puts("register #{inspect(client_pid)}")
        generator([client_pid | clients])
    after
      @interval ->
        IO.puts("tick")

        clients
        |> Enum.map(fn client ->
          send(client, {:tick})
        end)

        generator(clients)
    end
  end
end

defmodule Client do
  def start do
    Ticker.register(self())
    receiver()
  end

  def receiver do
    receive do
      {:tick} ->
        IO.puts("tock in client")
        receiver()
    end
  end
end

