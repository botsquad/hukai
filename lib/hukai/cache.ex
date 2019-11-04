defmodule Hukai.Cache do
  use GenServer

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @kinds ~w(adjective adverb noun verb animal color)a
  @locales ~w(en nl)

  # Server callbacks
  def init(_state) do
    {:ok, nil, 0}
  end

  def handle_info(:timeout, state) do
    # load the data
    counts =
      for kind <- @kinds, locale <- @locales do
        t = table_name(locale, kind)
        :ets.new(t, [:named_table, :protected])

        path = Application.app_dir(:hukai, "priv/corpus/#{locale}_#{kind}.txt")

        with {:ok, contents} <- File.read(path) do
          count =
            contents
            |> String.trim()
            |> String.split("\n")
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

    {:noreply, state}
  end

  def table_name(locale, kind) do
    :"hukai_#{locale}_#{kind}s"
  end
end
