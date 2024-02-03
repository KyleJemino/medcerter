defmodule MedcerterWeb.Components.VisitComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias Medcerter.Helpers.SharedHelpers
  alias Medcerter.Helpers.PatientHelpers, as: PH
  alias MedcerterWeb.Components.DoctorComponents, as: DC

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
      <DC.doctor_header
        doctor={@doctor}
        container_class="prescription-header -medcert"
      />
      <div class="medcert-date">
        <p><%= SharedHelpers.default_date_format(@visit.date_of_visit) %></p>
      </div>
      <div class="medcert-header">
        <h1 class="header -sm">
          MEDICAL CERTIFICATE 
        </h1>
      </div>
      <div class="medcert-body">
        <p class="content">
          This is to certify that patient 
          <span class="important">
            <%= "#{PH.get_full_name @patient}, #{PH.get_age @patient}/#{PH.display_sex @patient}," %>
          </span>
          has been seen and physically examined today at my clinic for check-up and management
          regarding his diagnosis of 
          <span class="important">
            <%= "#{@visit.diagnosis}." %>
          </span>
          <%= @visit.additional_remarks %>
        </p>

        <p class="content">
          Patient is advised to rest for <%= @visit.rest_days %> days to recuperate.
          Patient will be fit to work on <%= SharedHelpers.default_date_format @visit.fit_to_work %>.
        </p>
      </div>
      <DC.doctor_footer doctor={@doctor} />
    </div>
    """
  end
end
