defmodule Issues.CLI do
  @default_count 4
  @default_fields [
    {"number", "#"},
    "created_at",
    "title",
    "state",
    "comments",
    {"html_url", "link"}
  ]

  @moduledoc """
  Handle the command line parsing and the dispatch to
  the various functions that end up generating a
  table of the last _n_ issues in a github project
  """

  def main(argv) do
    argv
    |> parse_args
    |> process
  end

  @doc """
  `argv` can be -h or --help, which returns :help.
  Otherwise it is a github user name, project name, and (optionally)
  the number of entries to format.
  Return a tuple of `{ user, project, count }`, or `:help` if help was given.
  """
  def parse_args(argv) do
    parse =
      OptionParser.parse(argv,
        switches: [help: :boolean],
        aliases: [h: :help]
      )

    _parse_args(parse)

    # case parse do
    #   {[help: true], _, _} ->
    #     :help
    #
    #   {_, [user, project, count], _} ->
    #     {user, project, count}
    #
    #   {_, [user, project], _} ->
    #     {user, project, @default_count}
    #
    #   _ ->
    #     :help
    # end
  end

  defp _parse_args({[help: true], _, _}), do: :help
  defp _parse_args({_, [user, project, count], _}), do: {user, project, String.to_integer(count)}
  defp _parse_args({_, [user, project], _}), do: {user, project, @default_count}
  defp _parse_args({_, _, _}), do: :help

  def process(:help) do
    IO.puts("""
    usage: issues <user> <project> [ count | #{@default_count} ]
    """)

    System.halt(0)
  end

  def process({user, project, count}) do
    Issues.GithubIssues.fetch(user, project)
    |> decode_reponse()
    |> sort_desc
    |> Enum.take(count)
    |> Enum.reverse()
    |> Issues.Table.print(@default_fields)
  end

  def decode_reponse({:ok, body}), do: body

  def decode_reponse({:error, body}) do
    IO.puts("Error fetching from Github: #{body["message"]}")
    System.halt(2)
  end

  def sort_desc(list) do
    Enum.sort(list, fn a, b ->
      a["created_at"] >= b["created_at"]
    end)
  end
end
