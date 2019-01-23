defmodule Exercise3 do
  def sub(sender, msg) do
    send sender, msg
    raise "hey wrong"
  end

  def run do
    spawn_monitor(Exercise3, :sub, [self(), "yoyo"])
    spawn_monitor(Exercise3, :sub, [self(), "wowo"])

    :timer.sleep(2000)
    listen()
  end

  def listen do
    receive do
      msg ->
        IO.inspect(msg)
        listen()
      after 1000 ->
        IO.puts "nothing"
    end
  end
end

Exercise3.run()

# defmodule Exercise3 do
#   def sub(sender) do
#     receive do
#       msg ->
#         send sender, msg
#         raise "something wrong"
#     end
#   end
#
#   def run do
#     {pid, _} = spawn_monitor(Exercise3, :sub, [self()])
#     send pid, "wowow"
#     send pid, "hellow"
#
#     :timer.sleep(2000)
#     listen()
#   end
#
#   def listen do
#     receive do
#       msg ->
#         IO.inspect(msg)
#         listen()
#       after 1000 ->
#         IO.puts "nothing"
#     end
#   end
# end
#
# Exercise3.run()
