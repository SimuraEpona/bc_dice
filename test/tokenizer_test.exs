defmodule BCDice.TokenizerTest do
  use ExUnit.Case

  alias BCDice.Tokenizer

  test "int" do
    assert {:ok, [{:int, 1, '2'}]} == Tokenizer.tokenize("2")
  end

  test "roll" do
    expected = [
      {:int, 1, '1'},
      {:roll, 1, 'D'},
      {:int, 1, '6'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1d6")
    assert {:ok, expected} == Tokenizer.tokenize("1D6")
  end

  test "bara" do
    expected = [
      {:int, 1, '3'},
      {:bara_roll, 1, 'B'},
      {:int, 1, '6'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("3b6")
    assert {:ok, expected} == Tokenizer.tokenize("3B6")
  end

  test "operator" do
    expected = [
      {:int, 1, '1'},
      {:basic_operator, 1, '+'},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1+2")

    expected = [
      {:int, 1, '1'},
      {:basic_operator, 1, '-'},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1-2")

    expected = [
      {:int, 1, '1'},
      {:complex_operator, 1, '*'},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1*2")

    expected = [
      {:int, 1, '1'},
      {:complex_operator, 1, '/'},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1/2")
  end

  test "choice" do
    expected = [
      {:choice, 1, '2,3,4'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("CHOICE[2,3,4]")
    assert {:ok, expected} == Tokenizer.tokenize("choice[2,3,4]")

    expected = [
      {:choice, 1, '2,3,(A-B+RANDOM'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("CHOICE[2,3,(A-B+random]")
  end

  test "compare operator" do
    expected = [
      {:int, 1, '1'},
      {:compare_operator, 1, '>='},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1>=2")

    expected = [
      {:int, 1, '1'},
      {:compare_operator, 1, '='},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1=2")

    expected = [
      {:int, 1, '1'},
      {:compare_operator, 1, '<='},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1<=2")

    expected = [
      {:int, 1, '1'},
      {:compare_operator, 1, '>'},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1>2")

    expected = [
      {:int, 1, '1'},
      {:compare_operator, 1, '<'},
      {:int, 1, '2'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("1<2")
  end

  test "subexpressions" do
    expected = [
      {:"(", 1, '('},
      {:int, 1, '78'},
      {:complex_operator, 1, '*'},
      {:int, 1, '5'},
      {:")", 1, ')'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("(78*5)")
  end

  test "separator" do
    expected = [
      {:int, 1, '5'},
      {:",", 1, ','},
      {:int, 1, '6'},
      {:",", 1, ','},
      {:int, 1, '7'}
    ]

    assert {:ok, expected} == Tokenizer.tokenize("5,6,7")
  end

  test "errors" do
    assert {:error, {:tokenizing_failed, {:illegal, '$'}}} = Tokenizer.tokenize("1-3+$")
  end
end
