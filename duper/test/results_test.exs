defmodule ResultsTest do
  use ExUnit.Case
  alias Duper.Results

  test "can add entries to the results" do
    Results.add_hash_for("path1", 123)
    Results.add_hash_for("path2", 123)
    Results.add_hash_for("path3", 321)
    Results.add_hash_for("path4", 123)
    Results.add_hash_for("path5", 321)
    Results.add_hash_for("path6", 789)

    duplicates = Results.find_duplicates
    assert length(duplicates) == 2
    assert ~w{path4 path2 path1} in duplicates
    assert ~w{path5 path3} in duplicates
  end
end
