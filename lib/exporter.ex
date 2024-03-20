defmodule Exporter do
  def export_as_csv(path, debtors) do
    file = File.open!(path, [:write, :utf8])

    debtors
    |> CSV.encode(headers: [id: "ID", name: "Name", debt: "Debt"], separator: ?;)
    |> Enum.each(&IO.write(file, &1))

    :ok
  end
end
