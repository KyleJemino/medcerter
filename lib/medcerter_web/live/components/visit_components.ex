defmodule MedcerterWeb.Components.VisitComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.SharedHelpers

  def visit_info(assigns) do
    ~H"""
      <div class="patient-info-container">
        <div class="info-blurb -inline">
          <h3 class="header -sm">Diagnosis:</h3>
          <p class="text-content -lg"><%= @visit.diagnosis %></p>
        </div>
        <div class="info-blurb">
          <h3 class="header -sm">Additional Remarks:</h3>
          <p class="text-content -lg"><%= @visit.additional_remarks %></p>
        </div>
        <div class="info-blurb">
          <h3 class="header -sm">Interview Notes:</h3>
          <p class="text-content -lg"><%= @visit.interview_notes %></p>
        </div>
        <%= if not is_nil(@visit.fit_to_work) do %>
          <div class="info-blurb -inline">
            <h3 class="header -sm">Fit to Work Date:</h3>
            <p class="text-content -lg"><%= SharedHelpers.default_date_format(@visit.fit_to_work) %></p>
          </div>
        <% end %>
        <div class="info-blurb -inline">
          <h3 class="header -sm">Number of Rest Days:</h3>
          <p class="text-content -lg"><%= @visit.rest_days %></p>
        </div>
      </div>
    """
  end
end
