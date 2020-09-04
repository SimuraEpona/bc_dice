defmodule BCDice do
  @moduledoc """
  Documentation for `BCDice`.
  """
  import BCDice.Gettext

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

  def description() do
    gettext("""
      3D6 |> 3D6 dice
      3D6>=10 |> 3D6 sum value is greater or equal than 10, available compare operation is >=, >, <=, <, =
      3B6 |> the same as 3D6 dice, dont sum the value
      3B6>=5 |> 3B6 is greater or equal than 5's dice count
    """)
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
