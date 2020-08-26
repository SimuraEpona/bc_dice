defmodule BCDice.Parser do
  import NimbleParsec

  int = integer(min: 1, max: 3) |> label("integer")

  roll =
    int
    |> concat(string("D") |> replace(:roll) |> label("roll"))
    |> concat(int)
    |> eos()

  defparsec(:parse, roll)
end
