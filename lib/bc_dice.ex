defmodule BCDice do
  @moduledoc """
  Documentation for `BCDice`.
  """

  alias BCDice.Parser
  alias BCDice.Ast

  def parse(expression) do
    expression
    |> String.upcase()
    |> Parser.parse()
    |> unwrap()
  end

  def roll(expression) do
    expression
    |> parse()
    |> Ast.compile()
  end

  defp unwrap(result) do
    case result do
      {:ok, acc, "", _, _line, _offset} ->
        {:ok, acc}

      {:ok, _, rest, _, _line, _offset} ->
        {:error, "could not parse: " <> rest}

      {:error, reason, _rest, _context, _line, _offset} ->
        {:error, reason}
    end
  end
end
