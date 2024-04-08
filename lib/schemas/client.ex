defmodule Schemas.Client do
  use Ecto.Schema

  schema "clients" do
    field :name, :string
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end

end
