defmodule Management.Repo.Migrations.CreatePayments do
  use Ecto.Migration

  def change do
    create table(:payments) do
      add :product_code, :integer
      add :price, :float
      add :paid, :boolean
      add :date, :date
      add :client_id, references(:clients, on_delete: :delete_all)

      timestamps()
    end
  end
end
