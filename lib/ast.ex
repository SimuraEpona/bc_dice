defmodule BCDice.Ast do
  alias BCDice.Result

  @spec compile(any()) :: Result.t()
  def compile({:ok, ast}), do: eval(ast)
  def compile(err = {:error, _}), do: err

  defp eval([l, :barabara_roll, r]) when is_integer(l) and is_integer(r) do
    faces = roll(l, r)
    values = faces |> Enum.map(& &1.value) |> Enum.join(", ")
    value = values
    result = "(#{l}B#{r}) |> #{values}"

    {:ok, %{faces: faces, secret: false, result: result, value: value}}
  end

  defp eval([l, :roll, r]) when is_integer(l) and is_integer(r) do
    faces = roll(l, r)
    values = faces |> Enum.map(& &1.value) |> Enum.join(", ")
    value = faces |> Enum.map(& &1.value) |> Enum.sum()

    result = "(#{l}D#{r}) |> [#{values}] |> #{value}"

    {:ok, %{faces: faces, secret: false, result: result, value: value}}
  end

  @spec roll(integer(), integer()) :: Result.dices()
  defp roll(times, faces) do
    Enum.map(1..times, fn _ ->
      %{faces: faces, value: :rand.uniform(faces)}
    end)
  end
end
