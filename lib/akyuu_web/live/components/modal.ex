defmodule AkyuuWeb.Components.Modal do
  @moduledoc false

  use Surface.Component

  prop(x_show, :string)
  prop(close_action, :string)

  slot(header)
  slot(footer)
  slot(default)

  def render(assigns) do
    ~H"""
    <div class="modal" x-show={{ @x_show }} >
      <div class="modal-bg" @click={{ @close_action }}></div>
      <div class="modal-content">
        <div class="modal-header">
          <slot name="header"/>
        </div>

        <div class="modal-default">
          <slot name="default"/>
        </div>

        <div class="modal-footer">
          <slot name="footer"/>
        </div>
      </div>
    </div>
    """
  end
end
