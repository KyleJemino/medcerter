defmodule Medcerter.Clinics.Queries.DoctorClinicQuery do
  import Ecto.Query
  alias Medcerter.Clinics.DoctorClinic

  def query_doctor_clinic(params) do
    query_by(DoctorClinic, params)
  end

  use Medcerter, :basic_queries
end
