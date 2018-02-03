defmodule Mach do
  defmodule Stack do
    @opaque t :: {[integer], [integer], [integer]}

    def zero do
      {[], [], []}
    end

    def push({[], [], []}, e) do
      {[e], [e], [e]}
    end
    def push({x, y, z}, e) do
      {[min(hd(x), e)|x], [e|y], [max(hd(z), e)|z]}
    end

    def pop({[_|r], [e|s], [_|t]}) do
      {e, {r,s,t}}
    end

    def peek({_, [e|_], _}) do
      e
    end

    def minimum({[x|_], _, _}) do
      x
    end

    def maximum({_, _, [x|_]}) do
      x
    end
  end
end
