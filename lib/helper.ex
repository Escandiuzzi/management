defmodule Helper do
  def parse_string_as_float(string) do
    {value, _} = Float.parse(string)
    value
  end

  def parse_string_as_date(string) do
    string
    |> match_date_string_with_regex
    |> get_result_as_date(string)
  end

  defp match_date_string_with_regex(string) do
    Regex.run(~r/(?<day>\d{2})(?<month>\d{2})(?<year>\d{4})/, string)
  end

  defp get_result_as_date(nil, string) do
    [_, day, month, year] = Regex.run(~r/(?<day>\d{1})(?<month>\d{2})(?<year>\d{4})/, string)
    %{day: "0" <> day, month: month, year: year}
    |> create_date
  end

  defp get_result_as_date([_, day, month, year], _) do
    %{day: day, month: month, year: year}
    |> create_date
  end

  defp create_date(%{day: day, month: month, year: year} ) do
    {_, date} = Date.from_iso8601("#{year}-#{month}-#{day}")
    date
  end
end
