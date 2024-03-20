defmodule Management do
  @moduledoc """
  Documentation for `Management`.
  """

  @doc """
  test method to quick generate a csv file
  """
  def exec() do
    clients = parse_client_file("./resources/clients.txt")
    payments = parse_payment_file("./resources/payments.txt")

    debtors = get_debtors(clients, payments)
    Exporter.export_as_csv("./debtors.csv", debtors)
  end

  @doc """
  receives a clients path, payments path and output path and creates a csv with the clients debt
  """
  def get_csv_with_clients_debts(clients_filepath, payments_filepath, output_path) do
    clients = parse_client_file(clients_filepath)
    payments = parse_payment_file(payments_filepath)

    debtors = get_debtors(clients, payments)
    Exporter.export_as_csv(output_path, debtors)
  end

  @doc """
  Receives a clients file path and a payments path and return the debts from the clients
  """
  def get_clients_debts(client_filepath, payments_filepath) do
    clients = parse_client_file(client_filepath)
    payments = parse_payment_file(payments_filepath)

    get_debtors(clients, payments)
  end

  defp get_debtors(clients, payments) do
    clients
    |> Stream.map(fn client ->
      %{
        id: client[:id],
        name: client[:name],
        debt:
          payments
          |> Stream.filter(fn payment ->
            payment[:client_id] === client[:id]
          end)
          |> Stream.map(fn payment -> payment[:price] end)
          |> Enum.sum()
      }
    end)
    |> Enum.to_list()
  end

  @doc """
  Receives a filepath of clients and return an array with the clients mapped
  """
  def parse_client_file(filepath) do
    filepath
    |> File.stream!()
    |> Stream.map(fn line -> String.split(line, ";") end)
    |> Stream.map(fn client_data ->
      %{id: String.to_integer(Enum.at(client_data, 0)), name: Enum.at(client_data, 4)}
    end)
    |> Enum.to_list()
  end

  @doc """
  Receives a filepath of payments and return an array with the payments mapped
  """
  def parse_payment_file(filepath) do
    filepath
    |> File.stream!()
    |> Stream.map(fn line -> String.split(line, ";") end)
    |> Stream.map(fn payment_data ->
      %{
        client_id: String.to_integer(Enum.at(payment_data, 0)),
        date: Helper.parse_string_as_date(Enum.at(payment_data, 1)),
        product_code: String.to_integer(Enum.at(payment_data, 2)),
        price: Helper.parse_string_as_float(Enum.at(payment_data, 3)),
        paid: Enum.at(payment_data, 4) === "t"
      }
    end)
    |> Stream.filter(fn item -> item.paid === false end)
    |> Enum.to_list()
  end
end
