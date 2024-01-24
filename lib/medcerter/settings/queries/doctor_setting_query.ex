defmodule Medcerter.Settings.Queries.DoctorSettingQuery do
  import Ecto.Query
  alias Medcerter.Settings.DoctorSetting

  def query_doctor_setting(params) do
    query_by(DoctorSetting, params)
  end

  defp query_by(query, %{"doctor_id" => doctor_id} = params) do
    query
    |> where([q], q.doctor_id == ^doctor_id)
    |> query_by(Map.delete(params, "doctor_id"))
  end

  use Medcerter, :basic_queries
end
