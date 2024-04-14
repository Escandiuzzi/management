defmodule Database do
  def insert_clients(clients) do
    Enum.each(clients, fn client ->
      client
      |> insert_client
    end)
  end

  def insert_client(client) do
    Schemas.Client.changeset(%Schemas.Client{}, client)
    |> Management.Repo.insert()
  end

  def insert_payments(payments) do
    Enum.each(payments, fn payment ->
      payment
      |> insert_payment
    end)
  end

  def insert_payment(payment) do
    Schemas.Payment.changeset(%Schemas.Payment{}, payment)
    |> Management.Repo.insert()
  end

  def insert_transactions(transactions) do
    Enum.each(transactions, fn transaction ->
      transaction
      |> insert_transaction
    end)
  end

  def insert_transaction(transaction) do
    Schemas.Transaction.changeset(%Schemas.Transaction{}, transaction)
    |> Management.Repo.insert()
  end
end
