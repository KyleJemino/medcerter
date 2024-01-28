defmodule Medcerter.Settings do
  alias Medcerter.Settings.Resolvers.DoctorSettingResolver, as: DSR

  defdelegate get_doctor_setting_by_params(params \\ %{}), to: DSR
  defdelegate create_doctor_setting(attrs \\ %{}), to: DSR
  defdelegate change_doctor_setting(doctor_setting, attrs \\ %{}), to: DSR
end
