defmodule MedcerterWeb.Components.VisitComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.SharedHelpers
  alias Medcerter.Helpers.PatientHelpers

  def visit_info(assigns) do
    ~H"""
      <div class="patient-info-container">
        <h1 class="header -sm">Visit Information</h1>
        <div class="info-blurb -inline">
          <h3 class="key">Date of Visit</h3>
          <p class="value"><%= SharedHelpers.default_date_format(@visit.date_of_visit) %></p>
        </div>
        <div class="info-blurb -inline">
          <h3 class="key">Diagnosis</h3>
          <p class="value"><%= @visit.diagnosis %></p>
        </div>
        <div class="info-blurb">
          <h3 class="key">Additional Remarks</h3>
          <p class="value"><%= @visit.additional_remarks %></p>
        </div>
        <div class="info-blurb">
          <h3 class="key">Interview Notes</h3>
          <p class="value"><%= @visit.interview_notes %></p>
        </div>
        <%= if not is_nil(@visit.fit_to_work) do %>
          <div class="info-blurb -inline">
            <h3 class="key">Fit to Work Date</h3>
            <p class="value"><%= SharedHelpers.default_date_format(@visit.fit_to_work) %></p>
          </div>
        <% end %>
        <div class="info-blurb -inline">
          <h3 class="key">Number of Rest Days</h3>
          <p class="value"><%= @visit.rest_days %></p>
        </div>
      </div>
    """
  end

  def medcert_card_print(assigns) do
    ~H"""
    <div class="prescription-card">
      <div class="prescription-header">
        <p class="title"><%= @doctor.document_header %></p>
        <div class="contact-info-container">
          <%= for info <- @doctor.contact_information do %>
            <div class="contact-info-card">
              <p class="address"><%= info.address %></p>
              <p class="contact_nos"><%= info.contact_nos %></p>
              <%= if not is_nil(info.extra_info) do %>
                <p class="extra_info"><%= info.extra_info %></p>
              <% end %>
            </div>
          <% end %>
        </div>
      </div>
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
    </div>
    """
  end
end
