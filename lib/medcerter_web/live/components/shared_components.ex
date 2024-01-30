defmodule MedcerterWeb.Components.SharedComponents do
  use Phoenix.Component
  alias Phoenix.LiveView.JS

  def pop_up_menu(assigns) do
    assigns = 
      assigns
      |> assign_new(:container_class, fn -> "" end)
      |> assign_new(:button_class, fn -> "" end)
      |> assign_new(:list_class, fn -> "" end)

    ~H"""
      <div class={"pop-up-component #{@container_class}"}>
        <button 
          class={"button #{@button_class}"}
          phx-click={toggle_pop_up_menu(@target_id)}
        >
          <%= render_slot(@button_content) %>
        </button>
        <div 
          class="menu-list-container"
          id={"menu-list-container-#{@target_id}"}
          phx-click-away={toggle_pop_up_menu(@target_id)}
        >
          <div class={"menu-list #{@list_class}"}>
            <%= render_slot(@menu_content) %>
          </div>
        </div>
      </div>
    """
  end

  defp toggle_pop_up_menu(target_id) do
    JS.toggle(to: "#menu-list-container-#{target_id}")
  end
end
