defmodule MedcerterWeb.Components.PatientComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.PatientHelpers

  def patient_info(assigns) do
    ~H"""
      <div class="patient-info-container">
        <div class="info-blurb -inline">
          <h3 class="header -sm">Age</h3>
          <p class="text-content -lg -uppercase">
            <%= PatientHelpers.get_age(@patient) %>
          </p>
        </div>
        <div class="info-blurb -inline">
          <h3 class="header -sm">Sex</h3>
          <p class="text-content -lg -uppercase"><%= @patient.sex %></p>
        </div>
        <div class="info-blurb -inline">
          <h3 class="header -sm">Address</h3>
          <p class="text-content -lg -uppercase"><%= @patient.address %></p>
        </div>
        <div class="info-blurb">
          <h3 class="header -sm">Family History</h3>
          <p class="text-content -lg"><%= @patient.family_history || 'N/A' %></p>
        </div>
        <div class="info-blurb">
          <h3 class="header -sm">Allergies</h3>
          <p class="text-content -lg"><%= @patient.allergies || 'N/A' %></p>
        </div>
      </div>
    """
  end
end
