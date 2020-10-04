defmodule Akyuu.Migration do
  @moduledoc """
  This module defines some helper utilities for migrations.
  """
  use Ecto.Migration

  @doc """
  Creates a PGroonga fulltext index for specific columns of a table.

  ## Examples
  This snippet creates an index for the columns `title`, `romaji_title` and
  `english_title` of the table `tracks`.

      iex> create_fulltext_index(:tracks, [:title, :romaji_title, :english_title])
  """
  @spec create_fulltext_index(table :: atom(), columns :: [atom()]) :: :ok
  def create_fulltext_index(table, columns) do
    table_str = Atom.to_string(table)

    strings =
      columns
      |> Enum.map(fn x -> Atom.to_string(x) end)
      |> Enum.join(", ")

    execute(
      "CREATE INDEX #{table_str}_fulltext ON #{table_str} USING pgroonga(#{strings}) WITH (tokenizer='TokenBigramSplitSymbolAlphaDigit')"
    )
  end
end
