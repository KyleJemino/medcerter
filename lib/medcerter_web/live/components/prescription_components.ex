defmodule MedcerterWeb.Components.PrescriptionComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias MedcerterWeb.Router.Helpers, as: Routes
  alias Medcerter.Helpers.PatientHelpers

  def prescription_card(assigns) do
    ~H"""
    <div class="prescription-card">
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
              </div>
              <%= if not is_nil(medicine.brand) do %>
                <div class="brand">(<%= medicine.brand %>)</div>
              <% end %>
            </div>
            <div class="dosage">
              <%= medicine.dosage %>
            </div>
            <div class="quantity">
              <%= medicine.quantity %>
            </div>
          </div>
        <% end %>
      </div>
    </div>
    """
  end
end
