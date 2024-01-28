defmodule MedcerterWeb.Components.VisitComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.SharedHelpers

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
end
