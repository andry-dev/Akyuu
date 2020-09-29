defmodule Akyuu.Migration do
  use Ecto.Migration

  def create_fulltext_index(table, members) do
    table_str = Atom.to_string(table)

    strings =
      members
      |> Enum.map(fn x -> Atom.to_string(x) end)
      |> Enum.join(", ")

    execute(
      "CREATE INDEX #{table_str}_fulltext ON #{table_str} USING pgroonga(#{strings}) WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit')"
    )
  end
end
