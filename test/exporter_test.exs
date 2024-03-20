defmodule ExporterTest do
  use ExUnit.Case
  doctest Helper

  test("test") do

    debtors = [
      %{id: 5, name: "Client 5", debt: 9.77},
      %{id: 21, name: "Client 21", debt: 77.0}
    ]

    expected_result = :ok
    result = Exporter.export_as_csv("./test/resources/test.csv", debtors)

    assert result === expected_result
  end
end
