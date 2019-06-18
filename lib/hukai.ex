defmodule Hukai do
  @moduledoc """
  Pronouncable name generator
  """

  def generate(pattern \\ "%a %n", hash \\ nil) do
    pattern
    |> String.split("%")
    |> generate_next(hash, [])
    |> Enum.reverse()
    |> IO.chardata_to_string()
  end

  def hash(value, pattern \\ "%a %n") do
    hash_value = :erlang.term_to_binary({pattern, value}) |> XXHash.xxh32()
    generate(pattern, hash_value)
  end

  defp generate_next([], hash, acc), do: acc

  defp generate_next([item | rest], hash, acc) do
    generate_token(rest, hash, [item | acc])
  end

  defp generate_token([], _hash, acc), do: acc

  @all [
    {"n", :noun},
    {"v", :verb},
    {"a", :adjective},
    {"b", :adverb},
    {"A", :animal},
    {"C", :color}
  ]

  for {char, kind} <- @all do
    defp generate_token([unquote(char) <> item | rest], hash, acc) do
      generate_next([item | rest], hash, [pick(unquote(kind), hash) | acc])
    end
  end

  defp pick(kind, n \\ nil) do
    count = Application.get_env(:hukai, :corpus_counts)[kind]
    table = Hukai.Cache.table_name(kind)

    index =
      case n do
        nil -> Enum.random(0..(count - 1))
        _ -> rem(n, count)
      end

    [{_, word}] = :ets.lookup(table, index)
    word
  end
end
