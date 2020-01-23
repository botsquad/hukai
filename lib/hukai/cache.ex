defmodule Hukai.Cache do
  use GenServer

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @translatable_kinds ~w(animal color)a
  @kinds ~w(adjective adverb noun verb animal color)a
  @locales ~w(en nl)

  # Server callbacks
  def init(_state) do
    {:ok, nil, 0}
  end

  defp words(locale, kind) do
    path = Application.app_dir(:hukai, "priv/corpus/#{locale}_#{kind}.txt")

    with {:ok, contents} <- File.read(path) do
      words =
        contents
        |> String.trim()
        |> String.split("\n")

      {:ok, words}
    end
  end

  def handle_info(:timeout, state) do
    # load the data
    counts =
      for kind <- @kinds, locale <- @locales do
        t = table_name(locale, kind)
        :ets.new(t, [:named_table, :protected])

        with {:ok, words} <- words(locale, kind) do
          count =
            words
            |> Enum.with_index()
            |> Enum.map(fn {word, index} ->
              word = String.trim(word)
              :ets.insert(t, {index, word})
            end)
            |> Enum.count()

          {{locale, kind}, count}
        else
          _ -> nil
        end
      end
      |> Enum.filter(&(&1 != nil))

    Application.put_env(:hukai, :corpus_counts, Map.new(counts))

    for n <- 0..(Enum.count(@locales) - 1) do
      [from, to | _] = cycle(@locales, n)
      t = translation_table_name(from, to)
      :ets.new(t, [:named_table, :protected])
    end

    for kind <- @translatable_kinds do
      rows =
        for locale <- @locales do
          with {:ok, words} <- words(locale, kind) do
            words
          end
        end
        |> Enum.zip()
        |> Enum.map(&Tuple.to_list/1)

      from_to_lookup =
        0..(Enum.count(@locales) - 1)
        |> Enum.reduce(%{}, fn n, result ->
          locales = cycle(@locales, n)

          lookup =
            rows
            |> Enum.map(fn row ->
              [x, y | _] = cycle(row, n)
              {x, y}
            end)

          result |> Map.put(locales, lookup)
        end)

      for {[from, to], rows} <- from_to_lookup do
        t = translation_table_name(from, to)

        Enum.each(rows, fn row ->
          :ets.insert(t, row)
        end)
      end
    end

    {:noreply, state}
  end

  defp cycle(x, 0), do: x
  defp cycle([h | t], n), do: cycle(t ++ [h], n - 1)

  def table_name(locale, kind) do
    :"hukai_#{locale}_#{kind}"
  end

  def translation_table_name(from, to) do
    :"hukai_translation_#{from}_#{to}"
  end
end
