defmodule ProcessExercise1 do
  def echo(sender) do
    receive do
      token -> send(sender, token)
    end
  end

  def run do
    pid1 = spawn(ProcessExercise1, :echo, [self()])
    pid2 = spawn(ProcessExercise1, :echo, [self()])

    send(pid1, "fred")
    send(pid2, "betty")

    listen()
  end

  def listen do
    receive do
      token -> IO.inspect(token)
    end
    receive do
      token -> IO.inspect(token)
    end
  end
end
