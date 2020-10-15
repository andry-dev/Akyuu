defmodule AkyuuWeb.Components.EditableField do
  @moduledoc false

  use Surface.Component

  prop(class, :css_class)
  prop(initial_value, :string, default: "")
  prop(global, :boolean, default: false)
  prop(x_show, :string, default: "")
  prop(show, :string, default: "")

  slot(default)

  def render(assigns) do
    ~H"""
    <div class="editable-div" x-data={{ handle_global_xdata(@global) }} :show={{ @show }} x-show={{ @x_show }}>
      <div class="editable-default" x-show=" !edit_mode ">
        <span class={{ @class }}>{{ @initial_value }}</span>
        <button :if={{ !@global }} class="edit" @click="edit_mode = true" type="button"></button>
      </div>
      <div class="editable" x-show="edit_mode" x-cloak>
        <slot />
        <button :if={{ !@global }} class="save" @click="edit_mode = false" type="submit"></button>
        <button :if={{ !@global }} class="reset" @click="edit_mode = false" type="reset"></button>
      </div>
    </div>
    """
  end

  defp handle_global_xdata(global) do
    unless global do
      "{ edit_mode: false }"
    else
      ""
    end
  end
end

defmodule EditableText do
  use Surface.Component

  alias AkyuuWeb.Components.EditableField
  alias Surface.Components.Form.TextInput

  prop(class, :css_class)
  prop(type, :string, default: "text")
  prop(initial_value, :string, default: "")
  prop(form, :any, required: true)
  prop(field, :any)
  prop(global, :boolean, default: false)
  prop(placeholder, :string, default: "")
  prop(size, :integer, default: 1)
  prop(opts, :list, default: [])
  prop(x_show, :string, default: "")
  prop(show, :string, default: "")

  def render(assigns) do
    ~H"""
    <EditableField class={{ @class }} initial_value={{ @initial_value }} global={{ @global }} x_show={{ @x_show }} show={{ @show }}>
      <TextInput form={{ @form }} field={{ @field }} class="editable-field {{ @class }}" value={{ @initial_value }} opts={{ Keyword.merge([size: @size, placeholder: @placeholder], @opts) }} />
    </EditableField>
    """
  end
end

defmodule EditableNumber do
  use Surface.Component

  alias AkyuuWeb.Components.EditableField
  alias Surface.Components.Form.NumberInput

  prop(class, :css_class)
  prop(type, :string, default: "text")
  prop(initial_value, :string, default: "")
  prop(form, :any, required: true)
  prop(field, :any)
  prop(global, :boolean, default: false)
  prop(placeholder, :string, default: "")
  prop(size, :integer, default: 1)
  prop(opts, :list, default: [])

  def render(assigns) do
    ~H"""
    <EditableField class={{ @class }} initial_value={{ @initial_value }} global={{ @global }}>
      <NumberInput form={{ @form }} field={{ @field }} class="editable-field {{ @class }}" value={{ @initial_value }} opts={{ Keyword.merge([size: 1, placeholder: @placeholder], @opts) }} />
    </EditableField>
    """
  end
end
