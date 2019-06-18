defmodule HukaiTest do
  use ExUnit.Case
  doctest Hukai

  test "greets the world" do
    :rand.seed(:exsplus, {1, 2, 3})

    assert "eastern wear" == Hukai.generate()
    assert "era" == Hukai.generate("%n")
    assert "target" == Hukai.generate("%n")

    assert "The spatial toxin further gas the pranha." ==
             Hukai.generate("The %a %n %b %v the %n.")

    assert "hamster" == Hukai.generate("%A")
    assert "violet" == Hukai.generate("%C")
    assert "amber wolf" == Hukai.generate("%C %A")
  end

  test "hash" do
    assert Hukai.hash("foo") == Hukai.hash("foo")
    assert Hukai.hash(__MODULE__) == Hukai.hash(__MODULE__)

    r = make_ref()
    assert Hukai.hash(r) == Hukai.hash(r)
    assert Hukai.hash(make_ref()) != Hukai.hash(make_ref())
  end
end
