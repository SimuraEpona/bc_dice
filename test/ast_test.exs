defmodule BCDice.AstTest do
  use ExUnit.Case

  alias BCDice.Ast

  describe "roll dice test" do
    test "basic dice" do
      1..6
      |> Enum.each(
        &eventually_match(
          [1, :roll, 6],
          %{result: "(1D6) |> [#{&1}] |> #{&1}"}
        )
      )
    end

    test "big faces" do
      assert eventually_match([2, :roll, 100], %{result: "(2D100) |> [50, 50] |> 100"})
      assert eventually_match([2, :roll, 100], %{result: "(2D100) |> [1, 99] |> 100"})
      assert eventually_match([2, :roll, 100], %{result: "(2D100) |> [100, 100] |> 200"})
    end
  end

  describe "roll barabara dice test" do
    test "basic dice" do
      1..6
      |> Enum.each(&eventually_match([1, :barabara_roll, 6], %{result: "(1B6) |> #{&1}"}))
    end

    test "big faces" do
      assert eventually_match([2, :barabara_roll, 6], %{result: "(2B6) |> 1, 1"})
      assert eventually_match([2, :barabara_roll, 6], %{result: "(2B6) |> 6, 6"})
    end
  end

  describe "compare roll dice" do
    test "basic dice" do
      assert eventually_match([1, :roll, 6, :>=, 3], %{result: "(1D6>=3) |> [4] |> 4 |> success"})
      assert eventually_match([1, :roll, 6, :>=, 3], %{result: "(1D6>=3) |> [1] |> 1 |> fail"})
      assert eventually_match([1, :roll, 6, :>, 3], %{result: "(1D6>3) |> [4] |> 4 |> success"})
      assert eventually_match([1, :roll, 6, :>, 3], %{result: "(1D6>3) |> [1] |> 1 |> fail"})
      assert eventually_match([1, :roll, 6, :<=, 3], %{result: "(1D6<=3) |> [1] |> 1 |> success"})
      assert eventually_match([1, :roll, 6, :<=, 3], %{result: "(1D6<=3) |> [4] |> 4 |> fail"})
      assert eventually_match([1, :roll, 6, :<, 3], %{result: "(1D6<3) |> [1] |> 1 |> success"})
      assert eventually_match([1, :roll, 6, :<, 3], %{result: "(1D6<3) |> [4] |> 4 |> fail"})
      assert eventually_match([1, :roll, 6, :==, 3], %{result: "(1D6=3) |> [3] |> 3 |> success"})
      assert eventually_match([1, :roll, 6, :==, 3], %{result: "(1D6=3) |> [4] |> 4 |> fail"})
    end

    test "two dices" do
      assert eventually_match([2, :roll, 6, :>=, 3], %{
               result: "(2D6>=3) |> [4, 4] |> 8 |> success"
             })

      assert eventually_match([2, :roll, 6, :>=, 3], %{result: "(2D6>=3) |> [1, 1] |> 2 |> fail"})

      assert eventually_match([2, :roll, 6, :>, 3], %{result: "(2D6>3) |> [4, 4] |> 8 |> success"})

      assert eventually_match([2, :roll, 6, :>, 3], %{result: "(2D6>3) |> [1, 1] |> 2 |> fail"})

      assert eventually_match([2, :roll, 6, :<=, 3], %{
               result: "(2D6<=3) |> [1, 1] |> 2 |> success"
             })

      assert eventually_match([2, :roll, 6, :<=, 3], %{result: "(2D6<=3) |> [4, 4] |> 8 |> fail"})

      assert eventually_match([2, :roll, 6, :<, 3], %{result: "(2D6<3) |> [1, 1] |> 2 |> success"})

      assert eventually_match([2, :roll, 6, :<, 3], %{result: "(2D6<3) |> [4, 4] |> 8 |> fail"})

      assert eventually_match([2, :roll, 6, :==, 3], %{
               result: "(2D6=3) |> [1, 2] |> 3 |> success"
             })

      assert eventually_match([2, :roll, 6, :==, 3], %{result: "(2D6=3) |> [4, 4] |> 8 |> fail"})
    end
  end

  test "error test" do
    assert {:error, "could not parsed"} == Ast.compile({:error, "could not parsed"})
  end

  def eventually_match(parser, result) do
    Stream.repeatedly(fn ->
      Ast.compile({:ok, parser})
    end)
    |> Enum.find(fn {:ok, ast_result} ->
      ast_result.result == result.result
    end)
  end
end
