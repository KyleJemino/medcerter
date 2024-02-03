defmodule MedcerterWeb.Components.DoctorComponents do
  use Phoenix.Component

  def doctor_header(assigns) do
    ~H"""
      <div class={@container_class}>
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
    """
  end

  def doctor_footer(assigns) do
    ~H"""
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
    """
  end
end
