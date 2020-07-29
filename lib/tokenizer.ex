defmodule BCDice.Tokenizer do
  def tokenize(roll_string) do
    with charlist <- String.to_charlist(roll_string),
         {:ok, tokens, _} <- :dice_lexer.string(charlist) do
      {:ok, tokens}
    else
      {:error, {1, :dice_lexer, reason}, 1} ->
        {:error, {:tokenizing_failed, reason}}
    end
  end
end
