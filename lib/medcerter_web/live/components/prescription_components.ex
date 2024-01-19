defmodule MedcerterWeb.Components.PrescriptionComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.PatientHelpers

  def prescription_card(assigns) do
    ~H"""
    <div class="prescription-card">
      <div class="patient-information">
        <div class="patient-info-item">
          <span class="key">
            Name:
          </span>
          <span class="value">
            <%= PatientHelpers.get_full_name(@patient) %>
          </span>
        </div>
        <div class="info">
          <span class="key">
          </span>
          <span class="value">
          </span>
        </div>
        <div class="info">
          <span class="key">
          </span>
          <span class="value">
          </span>
        </div>
        <div class="info">
          <span class="key">
          </span>
          <span class="value">
          </span>
        </div>
        <div class="info">
          <span class="key">
          </span>
          <span class="value">
          </span>
        </div>
      </div>
    </div>
    """
  end
end
