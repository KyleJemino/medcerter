defmodule Medcerter.Helpers.SharedHelpers do
  def default_date_format(date), do: Timex.format!(date, "%b %d %Y", :strftime)
end
