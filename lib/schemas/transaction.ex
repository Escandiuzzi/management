defmodule Schemas.Transaction do
  use Ecto.Schema

  schema "transactions" do
    field :name, :string
    field :total_paid, :float
    field :pending, :float
    field :date, :date
    field :client_id, :integer
    timestamps([:inserted_at, :updated_at])
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:name, :total_paid, :pending, :date, :client_id])
    |> Ecto.Changeset.validate_required([:name, :total_paid, :pending, :date, :client_id])
  end
end
