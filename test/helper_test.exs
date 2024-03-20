defmodule HelperTest do
  use ExUnit.Case
  doctest Helper

  test "parse an integer string as a float" do
    string = "7"
    assert Helper.parse_string_as_float(string) === 7.0
  end

  test "parse an float string as a float" do
    string = "7.77"
    assert Helper.parse_string_as_float(string) === 7.77
  end

  test "parse a date string with a missing digit" do
    string = "7122024"

    {_, expected_result} = Date.from_iso8601("2024-12-07")
    result = Helper.parse_string_as_date(string)

    assert result === expected_result
  end

  test "parse a date string" do
    string = "23021999"

    {_, expected_result} = Date.from_iso8601("1999-02-23")
    result = Helper.parse_string_as_date(string)

    assert result === expected_result
  end

end
