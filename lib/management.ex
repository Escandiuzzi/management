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

    IO.inspect(Enum.count(payments))
    IO.inspect(Enum.count(Stream.filter(payments, fn payment -> payment[:client_id] === 0 end)))

    payments_relation = join_ordered_by_date(clients, payments)

    Exporter.export_as_csv("./payments_relation.csv", payments_relation)
  end

  @doc """
  receives a clients path, payments path and output path and creates a csv with the clients transactions
  """
  def get_csv_with_clients_transactions(clients_filepath, payments_filepath, output_path) do
    clients = parse_client_file(clients_filepath)
    payments = parse_payment_file(payments_filepath)

    payments_relation = join_ordered_by_date(clients, payments)
    Exporter.export_as_csv(output_path, payments_relation)
  end

  @doc """
  Receives a clients file path and a payments path and return the transactions from the clients
  """
  def get_clients_transactions(client_filepath, payments_filepath) do
    clients = parse_client_file(client_filepath)
    payments = parse_payment_file(payments_filepath)

    join_ordered_by_date(clients, payments)
  end

  defp join_ordered_by_date(clients, transactions) do
    clients
    |> join_clients_with_transactions(transactions)
    |> create_transaction_records_per_day()
    |> Enum.to_list()
  end

  defp join_clients_with_transactions(clients, transactions) do
    clients
    |> Stream.map(fn client ->
      transactions_from_client =
        transactions
        |> Enum.filter(fn payment -> payment[:client_id] === client[:id] end)
        |> Enum.group_by(fn payment -> payment[:date] end)

      %{
        name: client[:name],
        id: client[:id],
        transactions: transactions_from_client
      }
    end)
    |> Enum.sort(&(&1[:date] < &2[:date]))
  end

  defp create_transaction_records_per_day(clients) do
    clients
    |> Enum.reduce([], fn current_client, transactions_records ->
      # if current_client[:id] === 0 do
      #   IO.inspect(current_client)
      # end

      date_keys = Map.keys(current_client[:transactions])

      {_, _, records} =
        date_keys
        |> Enum.reduce({0, 0, []}, fn date_key, {total, pending, client_records} ->
          transactions = current_client[:transactions][date_key]

          {total_paid_date, pending_date} =
            get_transactions_total_from_client_for_the_day(transactions, total, pending)

          {total_paid_date, pending_date,
           [
             %{
               name: current_client[:name],
               id: current_client[:id],
               date: date_key,
               total_paid: total_paid_date,
               pending: pending_date
             }
             | client_records
           ]}
        end)

      [records | transactions_records]
    end)
    |> Stream.flat_map(& &1)
    |> Enum.sort_by(& &1[:date])
  end

  defp get_transactions_total_from_client_for_the_day(transactions, total, pending) do
    transactions
    |> Enum.reduce({total, pending}, fn transaction, {paid, pending} ->
      paid_on_date = if transaction[:paid] === true, do: transaction[:price], else: 0
      pending_on_date = if transaction[:paid] === false, do: transaction[:price], else: 0

      temp_pending = pending + pending_on_date - paid_on_date

      calculated_pending =
        if temp_pending < 0 do
          0
        else
          temp_pending
        end

      {paid + paid_on_date, calculated_pending}
    end)
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
    |> Enum.to_list()
  end
end
