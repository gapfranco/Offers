defmodule Offers.Teach.Campus do
  use Ecto.Schema
  import Ecto.Changeset

  schema "campus" do
    field :city, :string
    field :name, :string
    belongs_to(:university, Offers.Teach.University)

    timestamps()
  end

  @doc false
  def changeset(campus, attrs) do
    campus
    |> cast(attrs, [:name, :city, :university_id])
    |> validate_required([:name, :city, :university_id])
    |> assoc_constraint(:university)
  end

  @doc false
  def update_changeset(campus, attrs) do
    campus
    |> cast(attrs, [:name])
    |> validate_required([:name])
  end
end
