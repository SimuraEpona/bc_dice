defmodule BCDice.AstTest do
  use ExUnit.Case

  alias BCDice.Ast

  describe "roll dice test" do
    test "basic dice" do
      assert eventually_match([1, :roll, 6], %{value: 1})
      assert eventually_match([1, :roll, 6], %{value: 2})
      assert eventually_match([1, :roll, 6], %{value: 6})
      assert eventually_match([1, :roll, 6], %{value: 4})
      assert eventually_match([1, :roll, 6], %{value: 5})
      assert eventually_match([1, :roll, 6], %{value: 6})
    end

    test "big faces" do
      assert eventually_match([2, :roll, 100], %{value: 100})
      assert eventually_match([2, :roll, 100], %{value: 100})
      assert eventually_match([2, :roll, 100], %{value: 200})
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
      ast_result.value == result.value
    end)
  end
end
