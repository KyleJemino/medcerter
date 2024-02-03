defmodule MedcerterWeb.Components.PrescriptionComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias MedcerterWeb.Router.Helpers, as: Routes
  alias Medcerter.Helpers.PatientHelpers
  alias MedcerterWeb.Components.SharedComponents, as: SC
  alias MedcerterWeb.Components.DoctorComponents, as: DC

  def prescription_card_print(assigns) do
    ~H"""
    <div class="prescription-card">
      <DC.doctor_header
        doctor={@doctor}
        container_class="prescription-header"
      />
      <div class="patient-information-container">
          <div class="patient-info-item -long">
            <span class="key">
              Name:
            </span>
            <span class="value">
              <%= PatientHelpers.get_full_name(@patient) %>
            </span>
          </div>
          <div class="patient-info-item">
            <span class="key">
              Age:
            </span>
            <span class="value">
              <%= PatientHelpers.get_age(@patient) %>
            </span>
          </div>
          <div class="patient-info-item">
            <span class="key">
              Sex:
            </span>
            <span class="value">
              <%= String.upcase("#{@patient.sex}") %>
            </span>
          </div>
          <div class="patient-info-item -long">
            <span class="key">
              Address:
            </span>
            <span class="value">
              <%= @patient.address %>
            </span>
          </div>
          <div class="patient-info-item">
            <span class="key">
              Date:
            </span>
            <span class="value">
              <%= Timex.format!(Date.utc_today(), "{0M}/{0D}/{YYYY}") %>
            </span>
          </div>
      </div>
      <img 
        src={Routes.static_path(MedcerterWeb.Endpoint, "/images/rx-icon.png")} 
        class="rx-icon"
      />
      <div class="medicine-list-container">
        <%= for {medicine, index} <- Enum.with_index(@prescription.medicines) do %>
          <div class="medicine-item">
            <div class="count">
              <%= "#{index + 1} )" %>
            </div>
            <div class="name">
              <div class="name">
                <%= medicine.name %>
                <%= if not is_nil(medicine.brand) do %>
                  (<%= medicine.brand %>)
                <% end %>
              </div>
            </div>
            <div class="dosage">
              <%= "Sig: #{medicine.dosage} for #{medicine.duration}" %>
            </div>
            <div class="quantity">
              <%= "##{medicine.quantity}" %>
            </div>
          </div>
        <% end %>
      </div>
      <DC.doctor_footer doctor={@doctor} />
    </div>
    """
  end

  def prescription_row(assigns) do
    ~H"""
      <div class="prescription-row">
        <%= for {medicine, index} <- Enum.with_index(@prescription.medicines) do %>
          <div class="prescription-item">
            <div class="count">
              <%= "#{index + 1} )" %>
            </div>
            <div class="name">
              <div class="name">
                <%= medicine.name %>
                <%= if not is_nil(medicine.brand) do %>
                  (<%= medicine.brand %>)
                <% end %>
              </div>
            </div>
            <div class="dosage">
              <%= "Sig: #{medicine.dosage} for #{medicine.duration}" %>
            </div>
            <div class="quantity">
              <%= "##{medicine.quantity}" %>
            </div>
            <%= if (index == 0) do %>
              <SC.pop_up_menu 
                target_id={@prescription.id}
                container_class="prescription-pop-up-container"
                button_class="prescription-pop-up-button"
                list_class="prescription-pop-up-list-class"
              >
                <:button_content>
                  <Icons.FontAwesome.Solid.gear class="pop-up-icon" />
                </:button_content>
                <:menu_content>
                  <%= live_patch "Edit", to: @edit_route, class: "item" %>
                  <%= live_patch "Print", to: Routes.prescription_print_path(MedcerterWeb.Endpoint, :print, @prescription), class: "item" %>
                  <button 
                    class="item"
                    phx-click="delete-prescription"
                    phx-value-prescription-id={@prescription.id}
                  >
                    Delete
                  </button>
                </:menu_content>
              </SC.pop_up_menu>
            <% end %>
          </div>
        <% end %>
      </div>
    """
  end
end
