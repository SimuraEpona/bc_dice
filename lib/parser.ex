defmodule BCDice.Parser do
  import NimbleParsec

  int = integer(min: 1, max: 3) |> label("integer")

  dice = string("D") |> replace(:roll) |> label("roll")
  barabara_dice = string("B") |> replace(:barabara_roll) |> label("barabara roll")

  roll =
    int
    |> concat([dice, barabara_dice] |> choice())
    |> concat(int)
    |> eos()

  defparsec(:parse, roll)
end
