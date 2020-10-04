defmodule AkyuuWeb.View.Helpers do
  @moduledoc false

  def add_if_possible(list, condition, val) do
    if condition do
      list ++ [val]
    else
      list
    end
  end

  def add_if_possible(list, condition, val) when is_list(val) do
    if condition do
      list ++ val
    else
      list
    end
  end
end
