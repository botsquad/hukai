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
    assert "green" == Hukai.generate("%C")
    assert "beige porcupine" == Hukai.generate("%C %A")
  end

  test "nl locale" do
    :rand.seed(:exsplus, {1, 2, 3})

    assert "haas" == Hukai.generate("%A", "nl")
    assert "blauwe" == Hukai.generate("%C", "nl")
    assert "blauwe slang" == Hukai.generate("%C %A", "nl")
  end

  test "hash" do
    assert Hukai.hash("foo") == Hukai.hash("foo")
    assert Hukai.hash(__MODULE__) == Hukai.hash(__MODULE__)

    r = make_ref()
    assert Hukai.hash(r) == Hukai.hash(r)
    assert Hukai.hash(make_ref()) != Hukai.hash(make_ref())
  end

  test "translate" do
    assert "violet donkey" = Hukai.translate("paarse ezel", "nl", "en")
    assert "green monkey" = Hukai.translate("groene aap", "nl", "en")

    assert "blauwe olifant" = Hukai.translate("blue elephant", "en", "nl")
  end
end
