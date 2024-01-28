defmodule MedcerterWeb.Components.PrescriptionComponents do
  use Phoenix.Component
  use Phoenix.HTML
  alias MedcerterWeb.Router.Helpers, as: Routes
  alias Medcerter.Helpers.PatientHelpers

  def prescription_card_print(assigns) do
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
      <div class="doctor-legal-info-wrapper">
        <div class="doctor-legal-info-container">
          <p class="legal-info">
            <span class="key">Physician:</span>
            <span class="value"></span>
          </p>
          <p class="legal-info">
            <span class="key">Lic No:</span>
            <span class="value"><%= @doctor.license_no %></span>
          </p>
          <p class="legal-info">
            <span class="key">PTR No:</span>
            <span class="value"><%= @doctor.ptr_no %></span>
          </p>
          <p class="legal-info">
            <span class="key">S2 No:</span>
            <span class="value"><%= @doctor.s2_no %></span>
          </p>
        </div>
      </div>
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
          </div>
        <% end %>
      </div>
    """
  end
end
