defmodule Hukai.Cache do
  use GenServer

  # Client API
  def start_link(_) do
    GenServer.start_link(__MODULE__, [], name: __MODULE__)
  end

  @kinds ~w(adjective adverb noun verb)a

  # Server callbacks
  def init(state) do
    {:ok, nil, 0}
  end

  def handle_info(:timeout, state) do
    # load the data
    counts =
      for kind <- @kinds do
        t = table_name(kind)
        :ets.new(t, [:named_table, :protected])

        count =
          Application.app_dir(:hukai, "priv/corpus/#{kind}s.txt")
          |> File.read!()
          |> String.split("\n")
          |> Enum.with_index()
          |> Enum.map(fn {word, index} ->
            word = String.trim(word)
            :ets.insert(t, {index, word})
          end)
          |> Enum.count()

        {kind, count}
      end

    Application.put_env(:hukai, :corpus_counts, counts)

    {:noreply, state}
  end

  def table_name(kind) do
    :"hukai_#{kind}s"
  end
end
