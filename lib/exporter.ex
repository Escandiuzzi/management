defmodule Exporter do
  def export_as_csv(path, clients) do
    file = File.open!(path, [:write, :utf8])

    clients
    |> CSV.encode(
      headers: [
        id: "ID",
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
