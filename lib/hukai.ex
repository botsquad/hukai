defmodule Hukai do
  @moduledoc """
  Pronouncable name generator
  """

  @default_locale "en"
  @default_pattern "%a %n"

  def generate(pattern \\ @default_pattern, locale \\ @default_locale) do
    generate(pattern, locale, nil)
  end

  defp generate(pattern, locale, hash) do
    pattern
    |> String.split("%")
    |> generate_next(locale, hash, [])
    |> Enum.reverse()
    |> IO.chardata_to_string()
  end

  def hash(value, pattern \\ @default_pattern, locale \\ @default_locale) do
    hash_value = :erlang.term_to_binary({pattern, value}) |> XXHash.xxh32()
    generate(pattern, locale, hash_value)
  end

  defp generate_next([], _locale, _hash, acc), do: acc

  defp generate_next([item | rest], locale, hash, acc) do
    generate_token(rest, locale, hash, [item | acc])
  end

  defp generate_token([], _locale, _hash, acc), do: acc

  @all [
    {"n", :noun},
    {"v", :verb},
    {"a", :adjective},
    {"b", :adverb},
    {"A", :animal},
    {"C", :color}
  ]
  @locales ["en", "nl"]

  for {char, kind} <- @all, locale <- @locales do
    defp generate_token([unquote(char) <> item | rest], unquote(locale), hash, acc) do
      generate_next([item | rest], unquote(locale), hash, [
        pick(unquote(locale), unquote(kind), hash) | acc
      ])
    end
  end

  defp generate_token(_, _, _, _) do
    raise RuntimeError, "Unsupported locale or token type"
  end

  defp pick(locale, kind, n) do
    count = Application.get_env(:hukai, :corpus_counts)[{locale, kind}]
    table = Hukai.Cache.table_name(locale, kind)

    index =
      case n do
        nil -> Enum.random(0..(count - 1))
        _ -> rem(n, count)
      end

    [{_, word}] = :ets.lookup(table, index)
    word
  end

  def translate(sentence, from, to) do
    sentence
    |> String.trim()
    |> String.split(" ")
    |> Enum.map(fn token ->
      table = Hukai.Cache.translation_table_name(from, to)

      case :ets.lookup(table, token) do
        [{^token, translated}] -> translated
        _ -> token
      end
    end)
    |> Enum.join(" ")
  end
end
