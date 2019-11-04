defmodule HukaiTest do
  use ExUnit.Case
  doctest Hukai

  test "generating" do
    :rand.seed(:exsplus, {1, 2, 3})

    assert "usual lesion" == Hukai.generate()
    assert "fleck" == Hukai.generate("%n")
    assert "ballet" == Hukai.generate("%n")

    assert "The baneful tiller mainly jeers the clean." ==
             Hukai.generate("The %a %n %b %v the %n.")

    assert "rat" == Hukai.generate("%A")
    assert "crimson" == Hukai.generate("%C")
    assert "cyan porcupine" == Hukai.generate("%C %A")
  end

  test "nl locale" do
    :rand.seed(:exsplus, {1, 2, 3})

    assert "krokodil" == Hukai.generate("%A", "nl")
    assert "zwarte" == Hukai.generate("%C", "nl")
    assert "beige vis" == Hukai.generate("%C %A", "nl")
  end

  test "hash" do
    assert Hukai.hash("foo") == Hukai.hash("foo")
    assert Hukai.hash(__MODULE__) == Hukai.hash(__MODULE__)

    r = make_ref()
    assert Hukai.hash(r) == Hukai.hash(r)
    assert Hukai.hash(make_ref()) != Hukai.hash(make_ref())
  end
end
