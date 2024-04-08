defmodule Management.Repo.Migrations.CreateTransactions do
  use Ecto.Migration

  def change do
    create table(:transactions) do
      add :name, :string
      add :total_paid, :float
      add :pending, :float
      add :date, :date
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end
  end
end
