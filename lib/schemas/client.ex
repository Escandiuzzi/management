defmodule Schemas.Client do
  use Ecto.Schema

  schema "clients" do
    field :name, :string
    timestamps([:inserted_at, :updated_at])
  end

  def changeset(person, params \\ %{}) do
    person
    |> Ecto.Changeset.cast(params, [:id, :name])
    |> Ecto.Changeset.validate_required([:id, :name])
  end

end
