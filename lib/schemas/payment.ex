defmodule Schemas.Payment do
  use Ecto.Schema

  schema "payments" do
    field :product_code, :integer
    field :price, :float
    field :paid, :boolean
    field :date, :date
    field :client_id, :integer
    timestamps([:inserted_at, :updated_at])
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:client_id, :product_code, :price, :paid, :date])
    |> Ecto.Changeset.validate_required([:client_id, :product_code, :price, :paid, :date])
  end
end
