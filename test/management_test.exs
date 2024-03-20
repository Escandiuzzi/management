defmodule ManagementTest do
  use ExUnit.Case
  doctest Management

  test "read a file of clients and return an array with the clients mapped" do
    filepath = "./resources/clients.test.txt"

    expected_result = [
      %{id: 5, name: "Client 5"},
      %{id: 21, name: "Client 21"}
    ]

    assert Management.parse_client_file(filepath) === expected_result
  end

  test "read a file of payments and return an array with the payments mapped" do
    filepath = "./resources/payments.test.txt"

    expected_result = [
      %{date: ~D[2014-02-15], client_id: 5, product_code: 1, price: 2.0, paid: false},
      %{date: ~D[2014-02-15], client_id: 5, product_code: 1, price: 7.77, paid: false},
      %{date: ~D[2014-02-15], client_id: 21, product_code: 1, price: 77.0, paid: false}
    ]

    assert Management.parse_payment_file(filepath) === expected_result
  end

  test "read files from clients and payments and return a map with clients debts" do
    client_filepath = "./resources/clients.test.txt"
    payment_filepath = "./resources/payments.test.txt"

    expected_result = [
      %{id: 5, name: "Client 5", debt: 9.77},
      %{id: 21, name: "Client 21", debt: 77.0}
    ]

    result = Management.get_clients_debts(client_filepath, payment_filepath)

    assert result === expected_result
  end
end
