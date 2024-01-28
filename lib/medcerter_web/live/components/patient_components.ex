defmodule MedcerterWeb.Components.PatientComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.PatientHelpers

  def patient_info(assigns) do
    ~H"""
      <div class="patient-info-container">
        <h1 class="header -sm">Bio</h1>
        <div class="info-blurb -inline">
          <h3 class="key">Birthday</h3>
          <p class="value"><%= Timex.format!(@patient.birth_date, "%b %d, %Y", :strftime) %></p>
        </div>
        <div class="info-blurb -inline">
          <h3 class="key">Age</h3>
          <p class="value">
            <%= PatientHelpers.get_age(@patient) %>
          </p>
        </div>
        <div class="info-blurb -inline">
          <h3 class="key">Sex</h3>
          <p class="value -uppercase"><%= @patient.sex %></p>
        </div>
        <div class="info-blurb">
          <h3 class="key">Address</h3>
          <p class="value"><%= @patient.address %></p>
        </div>
        <div class="info-blurb">
          <h3 class="key">Allergies</h3>
          <p class="value"><%= @patient.allergies || 'N/A' %></p>
        </div>
        <div class="info-blurb">
          <p class="key">Family History</p>
          <p class="value"><%= @patient.family_history || 'N/A' %></p>
        </div>
      </div>
    """
  end
end
