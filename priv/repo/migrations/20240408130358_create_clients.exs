defmodule Management.Repo.Migrations.CreateClients do
  use Ecto.Migration

  def change do
    create table(:clients, primary_key: false) do
      add :id, :integer, primary_key: true
      add :name, :string

      timestamps()
    end
  end
end
