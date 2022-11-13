defmodule DomainChampionTest do
  use ExUnit.Case
  doctest DomainChampion

  @tag timeout: :infinity
  test "greets the world" do
    assert DomainChampion.hello() == :world
  end
end
