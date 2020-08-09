defmodule BCDice do
  @moduledoc """
  Documentation for `BCDice`.
  """

  alias BCDice.{Tokenizer, Parser}

  @doc """
  Hello world.

  ## Examples

      iex> BCDice.hello()
      :world

  """
  def hello do
    :world
  end

  @doc """
  helper function for `BCDice.Tokenizer.tokenize/1`
  """
  def tokenize(roll_string), do: Tokenizer.tokenize(roll_string)

  @doc """
  helper function for `BCDice.Parser.parse/1`
  """
  def parse(tokens), do: Parser.parse(tokens)
end
