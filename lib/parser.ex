defmodule BCDice.Parser do
  import NimbleParsec

  int = integer(min: 1, max: 3)

  roll =
    int
    |> concat(string("D") |> replace(:roll))
    |> concat(int)

  defparsec(:parse, roll)
end
