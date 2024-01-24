defmodule Medcerter.Settings.Resolvers.DoctorSettingResolver do
  alias Medcerter.Repo
  alias Medcerter.Settings.DoctorSetting
  alias Medcerter.Settings.Queries.DoctorSettingQuery, as: DSQ

  def get_doctor_setting_by_params(params \\ %{}) do
    params
    |> DSQ.query_doctor_setting()
    |> Repo.one()
  end

  def create_doctor_setting(attrs \\ %{}) do
    %DoctorSetting{}
    |> change_doctor_setting(attrs)
    |> Repo.insert()
  end

  def change_doctor_setting(%DoctorSetting{} = doctor_setting, attrs) do
    DoctorSetting.changeset(doctor_setting, attrs)
  end
end
