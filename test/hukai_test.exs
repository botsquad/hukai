defmodule HukaiTest do
  use ExUnit.Case
  doctest Hukai

  test "greets the world" do
    assert "happiest petulance" == Hukai.generate()
    assert "restaurateur" == Hukai.generate("%n")
    assert "weekend" == Hukai.generate("%n")

    assert "The jeweled pinochle prophetically streamed the soaking." ==
             Hukai.generate("The %a %n %b %v the %n.")
  end

  test "hash" do
    assert Hukai.hash("foo") == Hukai.hash("foo")
    assert Hukai.hash(__MODULE__) == Hukai.hash(__MODULE__)

    r = make_ref()
    assert Hukai.hash(r) == Hukai.hash(r)
    assert Hukai.hash(make_ref()) != Hukai.hash(make_ref())
  end
end
