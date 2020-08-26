defmodule BCDice.Result do
  @typep result :: String.t()
  @typep secret :: boolean()
  @typep dice :: %{faces: integer(), value: integer()}
  @typep dices :: [dice]
  @typep value :: integer() | boolean() | String.t()

  @type t ::
          {:ok, %{result: result(), secret: secret(), dices: dices, value: value()}}
          | {:error, any()}
end
