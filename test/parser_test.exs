defmodule BCDice.ParserTest do
  use ExUnit.Case

  alias BCDice.Parser

  defp roll(expr), do: expr |> Parser.parse() |> unwrap()

  defp unwrap({:ok, acc, "", _, _, _}), do: acc
  defp unwrap({:ok, _, rest, _, _, _}), do: {:error, "could not parse", rest}
  defp unwrap({:error, reason, _, _, _, _}), do: {:error, reason}

  describe "roll dice" do
    test "basic roll dice" do
      assert roll("1D6") == [1, :roll, 6]
    end

    test "error format is wrong" do
      assert roll("1D1000") == {:error, "expected end of string"}
      assert roll("1D100,s") == {:error, "expected end of string"}
      assert roll("a1D100") == {:error, "expected integer"}
      assert roll("1Da100") == {:error, "expected integer"}
    end
  end

  describe "barabara roll dice" do
    test "basic roll dice" do
      assert roll("1B6") == [1, :barabara_roll, 6]
    end

    test "error format is wrong" do
      assert roll("1B1000") == {:error, "expected end of string"}
      assert roll("1B100,s") == {:error, "expected end of string"}
      assert roll("a1B100") == {:error, "expected integer"}
      assert roll("1Ba100") == {:error, "expected integer"}
    end
  end
end
