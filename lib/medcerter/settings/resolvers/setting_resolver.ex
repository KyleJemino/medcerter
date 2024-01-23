defmodule Medcerter.Settings.Resolvers.DoctorSettingResolver do
  alias Medcerter.Repo
  alias Medcerter.Settings.DoctorSetting

  def create_doctor_setting(attrs \\ %{}) do
    %DoctorSetting{}
    |> change_doctor_setting(attrs)
    |> Repo.insert()
  end

  def change_doctor_setting(%DoctorSetting{} = doctor_setting, attrs) do
    DoctorSetting.changeset(doctor_setting, attrs)
  end
end
