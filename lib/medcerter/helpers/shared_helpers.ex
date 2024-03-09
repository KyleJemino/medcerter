defmodule Medcerter.Helpers.SharedHelpers do
  def default_date_format(date), do: Timex.format!(date, "%b. %d %Y", :strftime)

  def reject_at(enum, remove_index) do
    {result, _} =
      enum
      |> Enum.reduce({[], 0}, fn el, acc ->
        {list_acc, curr_index} = acc

        new_list =
          if (curr_index === remove_index) do
            list_acc
          else
            [el | list_acc]
          end

        {new_list, curr_index + 1}
      end)

    Enum.reverse result
  end
end
