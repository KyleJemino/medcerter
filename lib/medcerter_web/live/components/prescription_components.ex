defmodule MedcerterWeb.Components.PrescriptionComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias MedcerterWeb.Router.Helpers, as: Routes
  alias Medcerter.Helpers.PatientHelpers

  def prescription_card(assigns) do
    ~H"""
    <div class="prescription-card">
      <div class="patient-information-container">
        <div class="row">
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
        </div>
        <div class="row">
          <div class="patient-info-item -long">
            <span class="key">
              Address:
            </span>
            <span class="value">
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
      </div>
      <img 
        src={Routes.static_path(MedcerterWeb.Endpoint, "/images/rx-icon.png")} 
        class="rx-icon"
      />
    </div>
    """
  end
end
