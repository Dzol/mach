defmodule MachTest do
  use ExUnit.Case
  use ExUnitProperties

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

  defmodule CallProfile do
    def count(m, f, a) do
      {m, _, x} = :cprof.analyse(m)
      {_, c} = List.keyfind(x, {m, f, a}, 0, 0)
      c
    end
  end

  test "asking extrema is constant in List.head/1" do
    ## given
    x = for _ <- 0..255, do: :rand.uniform(255)
    interleave = fn (e, r) ->
      s = Mach.Stack.push(r, e)
      Mach.Stack.minimum(s)
      Mach.Stack.maximum(s)
      s
    end
    ## when
    :cprof.start()
    Enum.reduce(x, Mach.Stack.zero(), interleave)
    :cprof.pause()
    m = CallProfile.count(Mach.Stack, :minimum, 1)
    n = CallProfile.count(Mach.Stack, :maximum, 1)
    ## then
    assert CallProfile.count(List, :first, 1) === m + n
    :cprof.stop()
  end

  test "0: maximum/1 is biggest element pushed on" do
    alias Mach.Stack

    x = [8,16,42,23,15,4]
    |> Enum.reduce(Stack.zero(), &Stack.push(&2, &1))
    assert Stack.maximum(x) === 42
  end

  test "1: maximum/1 is biggest element pushed on" do
    alias Mach.Stack

    x = [4,8,15,16,23,42]
    |> Enum.shuffle()
    |> Enum.reduce(Stack.zero(), &Stack.push(&2, &1))
    assert Stack.maximum(x) === 42
  end

  test "2: maximum/1 is biggest element pushed on" do
    alias Mach.Stack

    x = 0..255
    |> Enum.shuffle()
    |> Enum.reduce(Stack.zero(), &Stack.push(&2, &1))
    assert Stack.maximum(x) === 255
  end

  test "3: maximum/1 is biggest element pushed on" do
    alias Mach.Stack

    m = 255; x = 0..m
    |> Enum.shuffle()
    |> Enum.reduce(Stack.zero(), &Stack.push(&2, &1))
    assert Stack.maximum(x) === m
  end

  property "maximum/1 is biggest element pushed on" do
    alias Mach.Stack

    check all i <- list_of(integer(), min_length: 1) do
      o = Enum.reduce(i, Stack.zero(), &Stack.push(&2, &1))
      assert Stack.maximum(o) === Enum.max(i)
    end
  end

  property "minimum/1 is smallest element pushed on" do
    alias Mach.Stack

    check all i <- list_of(integer(), min_length: 1) do
      o = Enum.reduce(i, Stack.zero(), &Stack.push(&2, &1))
      assert Stack.minimum(o) === Enum.min(i)
    end
  end

  property "peek/1 is last element pushed on" do
    alias Mach.Stack

    check all i <- list_of(integer(), min_length: 1) do
      o = Enum.reduce(i, Stack.zero(), &Stack.push(&2, &1))
      assert Stack.peek(o) === List.last(i)
    end
  end
end
