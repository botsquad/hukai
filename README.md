# Hukai

Generate Heroku-like pronouncable strings in Elixir; inspired by [spicy proton](https://github.com/schmich/spicy-proton).

Thanks to [NLTK](http://www.nltk.org/) for the word corpus.

Word lists are stored in runtime in a public-read ETS table.

## Installation

If [available in Hex](https://hex.pm/docs/publish), the package can be installed
by adding `hukai` to your list of dependencies in `mix.exs`:

```elixir
def deps do
  [
    {:hukai, "~> 0.1.0"}
  ]
end
```

Documentation can be generated with [ExDoc](https://github.com/elixir-lang/ex_doc)
and published on [HexDocs](https://hexdocs.pm). Once published, the docs can
be found at [https://hexdocs.pm/hukai](https://hexdocs.pm/hukai).
