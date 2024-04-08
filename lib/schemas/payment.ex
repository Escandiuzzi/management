defmodule Schemas.Payment do
  use Ecto.Schema

  schema "payments" do
    field :name, :string
    field :total_paid, :float
    field :pending, :float
    field :date, :date
    field :client_id, :integer
  end
end
