defmodule AkyuuWeb.Components.Empty do
  @moduledoc false
  use Surface.Component

  def render(assigns) do
    ~H"""
    <slot/>
    """
  end
end
