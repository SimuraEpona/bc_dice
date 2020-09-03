defmodule BCDice.Parser do
  import NimbleParsec

  int = integer(min: 1, max: 3) |> label("integer")

  dice = string("D") |> replace(:roll) |> label("roll")
  barabara_dice = string("B") |> replace(:barabara_roll) |> label("barabara roll")

  gt = string(">") |> replace(:>)
  gte = string(">=") |> replace(:>=)
  lt = string("<") |> replace(:<)
  lte = string("<=") |> replace(:<=)
  eq = string("=") |> replace(:==)

  compare = [gte, gt, lte, lt, eq] |> choice()

  defcombinatorp(
    :roll,
    int
    |> concat(dice)
    |> concat(int)
  )

  defcombinatorp(
    :barabara_roll,
    int
    |> concat(barabara_dice)
    |> concat(int)
  )

  defcombinatorp(
    :roll_compare,
    parsec(:roll) |> concat(compare) |> concat(int)
  )

  defcombinatorp(
    :barabara_roll_compare,
    parsec(:barabara_roll) |> concat(compare) |> concat(int)
  )

  defparsec(
    :parse,
    [
      parsec(:barabara_roll_compare),
      parsec(:roll_compare),
      parsec(:barabara_roll),
      parsec(:roll)
    ]
    |> choice()
    |> eos()
  )
end
