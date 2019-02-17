defmodule Sequence do
  @moduledoc """
  Documentation for Sequence.
  """

  use Application

  def start(type, _args) do
    Sequence.Application.start(type, Application.get_env(:sequence, :initial_number))
  end
end
