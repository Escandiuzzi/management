defmodule Exporter do
  def export_as_csv(path, transactions) do
    file = File.open!(path, [:write, :utf8])

    transactions
    |> CSV.encode(
      headers: [
        client_id: "ID",
        name: "Name",
        total_paid: "Total Paid",
        pending: "Pending",
        date: "Date"
      ],
      separator: ?;
    )
    |> Enum.each(&IO.write(file, &1))

    :ok
  end
end
