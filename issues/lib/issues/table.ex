defmodule Issues.Table do
  @moduledoc """
  Render a table
  """

  @doc """
  raw_fields: [ {"id", "#"}, "name" ]
  fields: [{"id", "#", {"name", "name"}]
  """
  def print(data, raw_fields) do
    IO.puts generate_content(data, format_fields(raw_fields))
  end

  def generate_one_line(row_data, column_widths) do
    row_data
    |> Enum.zip(column_widths)
    |> Enum.map_join(" | ", fn {cell, width} ->
      String.pad_trailing(cell, width)
    end)
  end

  def generate_header(fields, column_widths) do
    fields
    |> Enum.map(fn {_key, display} -> display end)
    |> generate_one_line(column_widths)
  end

  def generate_separator(column_widths) do
    column_widths
    |> Enum.map_join("-+-", &String.duplicate("-", &1))
  end

  def generate_body(data_by_row, column_widths) do
    data_by_row
    |> Enum.map(&generate_one_line(&1, column_widths))
    |> Enum.join("\n")
  end

  def generate_content(data, fields) do
    data_by_row = get_data_by_row(data, fields)
    column_widths = get_column_widths(data, fields)

    Enum.join(
      [
        generate_header(fields, column_widths),
        generate_separator(column_widths),
        generate_body(data_by_row, column_widths)
      ],
      "\n"
    )
  end

  def get_column_widths(data, fields) do
    for {key, _display} <- fields do
      for item <- data do
        printable(item[key])
      end
    end
    |> Enum.map(fn data ->
      Enum.max_by(data, &String.length/1) |> String.length()
    end)
    |> Enum.zip(for {_key, display} <- fields, do: String.length(display))
    |> Enum.map(fn {a, b} -> max(a, b) end)
  end

  def get_data_by_row(data, fields) do
    for item <- data do
      for {key, _display} <- fields do
        printable(item[key])
      end
    end
  end

  def printable(str) when is_binary(str), do: str
  def printable(str), do: to_string(str)

  def format_fields(fields) do
    for field <- fields, do: format_field(field)
  end

  defp format_field(field = {_key, _val}), do: field
  defp format_field(str), do: {str, str}
end
