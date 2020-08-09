defmodule BCDice.Parser do
  def parse(tokens) do
    case :dice_parser.parse(tokens) do
      {:ok, _} = resp -> resp
      {:error, {_, :dice_parser, reason}} -> {:error, {:token_parsing_failed, reason}}
    end
  end
end
