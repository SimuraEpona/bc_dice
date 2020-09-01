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

    test "error format" do
      assert {:error, _reason} = roll("1D1000")
      assert {:error, _reason} = roll("1D100,s")
      assert {:error, _reason} = roll("a1D100")
      assert {:error, _reason} = roll("1Da100,s")
    end
  end

  describe "barabara roll dice" do
    test "basic roll dice" do
      assert roll("1B6") == [1, :barabara_roll, 6]
    end

    test "error format" do
      assert {:error, _reason} = roll("1B1000")
      assert {:error, _reason} = roll("1B100,s")
      assert {:error, _reason} = roll("a1B1000")
      assert {:error, _reason} = roll("1Ba100,s")
    end
  end

  describe "compare roll dice" do
    test "basic compare dice" do
      assert roll("1D6>=5") == [1, :roll, 6, :>=, 5]
      assert roll("1D6>5") == [1, :roll, 6, :>, 5]
      assert roll("1D6<=5") == [1, :roll, 6, :<=, 5]
      assert roll("1D6<5") == [1, :roll, 6, :<, 5]
      assert roll("1D6=5") == [1, :roll, 6, :==, 5]
    end

    test "error format" do
      assert {:error, _reason} = roll("1D6>=s")
      assert {:error, _reason} = roll("1D6>=5s")
      assert {:error, _reason} = roll("1D6s>=5")
    end
  end
end
