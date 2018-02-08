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

  @tag :measure
  test "time complexity" do
    m = measure()
    |> Enum.map(&Integer.to_string/1)
    |> Enum.map(&Kernel.<>(&1, "\n"))
    |> Enum.reduce("", &Kernel.<>/2)
    File.write("time.data", m)
  end

  defp measure do
    measure(Mach.Stack.zero(), 255)
  end

  defp measure(_, 0) do
    []
  end
  defp measure(x, n) do
    y = push(x)
    {t, _} = :timer.tc(&peek/1, [y])
    [t|measure(y, n - 1)]
  end

  defp draw do
    Enum.random(0..255)
  end

  defp push(x) do
    Mach.Stack.push(x, draw())
  end

  defp peek(x) do
    ## No reason this couldn't be maximum/1
    :timer.sleep(1); Mach.Stack.minimum(x)
  end
end
