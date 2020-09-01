defmodule BCDice.Ast do
  alias BCDice.Result
  import BCDice.Gettext

  @spec compile(any()) :: Result.t()
  def compile({:ok, ast}), do: eval(ast)
  def compile(err = {:error, _}), do: err

  # 1B6
  defp eval([l, :barabara_roll, r]) when is_integer(l) and is_integer(r) do
    faces = roll(l, r)
    values = faces |> calc_values_from_faces()
    value = values
    result = "(#{l}B#{r}) |> #{values}"

    {:ok, %{faces: faces, secret: false, result: result, value: value}}
  end

  # 1D6>=5
  defp eval([l, :roll, r, compare, v]) when is_integer(l) and is_integer(r) and is_integer(v) do
    faces = roll(l, r)

    values = faces |> calc_values_from_faces()
    value = faces |> calc_value_from_faces()
    compare_string = compare |> Atom.to_string() |> String.replace("==", "=")

    ast = {compare, [], [value, v]}

    {compare_result, _} = Code.eval_quoted(ast)

    string = "(#{l}D#{r}#{compare_string}#{v}) |> [#{values}] |> #{value}"

    string =
      if compare_result do
        string <> " |> " <> gettext("success")
      else
        string <> " |> " <> gettext("fail")
      end

    {:ok, %{faces: faces, secret: false, result: string, value: value}}
  end

  # 1D6
  defp eval([l, :roll, r]) when is_integer(l) and is_integer(r) do
    faces = roll(l, r)
    values = faces |> calc_values_from_faces()
    value = faces |> calc_value_from_faces()

    result = "(#{l}D#{r}) |> [#{values}] |> #{value}"

    {:ok, %{faces: faces, secret: false, result: result, value: value}}
  end

  @spec roll(integer(), integer()) :: Result.dices()
  defp roll(times, faces) do
    Enum.map(1..times, fn _ ->
      %{faces: faces, value: :rand.uniform(faces)}
    end)
  end

  @doc false
  defp calc_values_from_faces(faces) do
    faces |> Enum.map(& &1.value) |> Enum.join(", ")
  end

  @doc false
  defp calc_value_from_faces(faces) do
    faces |> Enum.map(& &1.value) |> Enum.sum()
  end
end
