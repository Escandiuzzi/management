defmodule Importer do
  import Management

  def import do
    clients = parse_client_file("./resources/clients.txt")
    payments = parse_payment_file("./resources/payments.txt")

    import_clients(clients)
    import_payments(payments)
  end

  def import_clients(clients) do
    Enum.each(clients, fn client ->
      #IO.inspect(client)
      Database.insert_client(client)
    end)
  end

  def import_payments(payments) do
    Enum.each(payments, fn payment ->
      #IO.inspect(payment)
      Database.insert_payment(payment)
    end)
  end

end
