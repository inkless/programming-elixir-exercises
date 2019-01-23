defmodule TableTest do
  use ExUnit.Case
  # And allow us to capture stuff sent to stdout
  import ExUnit.CaptureIO

  @test_data [
    %{
      "id" => 100,
      "name" => "test1",
      "other" => "other1",
      "created_at" => "123123"
    },
    %{
      "id" => 101,
      "name" => "testtest2",
      "other" => "other2",
      "created_at" => "2345"
    }
  ]
  @test_fields [{"id", "#"}, "name", "created_at"]

  alias Issues.Table, as: TF

  doctest Issues

  test "format_fields" do
    assert TF.format_fields(@test_fields) == [
             {"id", "#"},
             {"name", "name"},
             {"created_at", "created_at"}
           ]
  end

  test "get_data_by_row" do
    assert TF.get_data_by_row(@test_data, TF.format_fields(@test_fields)) ==
             [["100", "test1", "123123"], ["101", "testtest2", "2345"]]
  end

  test "get_column_widths" do
    assert TF.get_column_widths(@test_data, TF.format_fields(@test_fields)) == [3, 9, 10]
  end

  test "generate_one_line" do
    assert TF.generate_one_line(["i", "am", "foo"], [3, 9, 10]) == "i   | am        | foo       "
  end

  test "generate_header" do
    assert TF.generate_header(TF.format_fields(@test_fields), [3, 9, 10]) ==
             "#   | name      | created_at"
  end

  test "generate_separator" do
    assert TF.generate_separator([3, 9, 10]) == "----+-----------+-----------"
  end

  test "generate_body" do
    assert TF.generate_body(
             TF.get_data_by_row(@test_data, TF.format_fields(@test_fields)),
             [3, 9, 10]
           ) <> "\n" ==
             """
             100 | test1     | 123123    
             101 | testtest2 | 2345      
             """
  end

  test "generate_content" do
    assert TF.generate_content(@test_data, TF.format_fields(@test_fields)) <> "\n" ==
             """
             #   | name      | created_at
             ----+-----------+-----------
             100 | test1     | 123123    
             101 | testtest2 | 2345      
             """
  end

  test "print" do
    result =
      capture_io(fn ->
        TF.print(@test_data, @test_fields)
      end)

    assert result == """
           #   | name      | created_at
           ----+-----------+-----------
           100 | test1     | 123123    
           101 | testtest2 | 2345      
           """
  end
end
