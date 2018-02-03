defmodule MachTest do
  use ExUnit.Case

  test "interface" do
    assert Mach.Stack.__info__(:functions) == [maximum: 1, minimum: 1, peek: 1, pop: 1, push: 2, zero: 0]
  end

  test "minimum/1" do
    ## given
    x = [4,8,15,16,23,42]
    ## when
    |> Enum.shuffle()
    |> Enum.reduce(Mach.Stack.zero(), &Mach.Stack.push(&2, &1))
    ## then
    assert Mach.Stack.minimum(x) === 4
  end

  test "maximum/1" do
    ## given
    x = [4,8,15,16,23,42]
    ## when
    |> Enum.shuffle()
    |> Enum.reduce(Mach.Stack.zero(), &Mach.Stack.push(&2, &1))
    ## then
    assert Mach.Stack.maximum(x) === 42
  end

  test "time complexity" do
    measure()
  end

  defp measure do
    measure(Mach.Stack.zero(), 255)
  end

  defp measure(_, 0) do
    []
  end
  defp measure(x, n) do
    y = insert(x)
    {t, {_, z}} = :timer.tc(&extract/1, [y])
    [t|measure(z, n - 1)]
  end

  defp draw do
    Enum.random(0..255)
  end

  defp insert(x) do
    x
    |> Mach.Stack.push(draw())
    |> Mach.Stack.push(draw())
  end

  defp extract(x) do
    :timer.sleep(1); Mach.Stack.pop(x)
  end
end
