defmodule Offers.Teach.Course do
  use Ecto.Schema
  import Ecto.Changeset
  alias Offers.Teach

  schema "courses" do
    field :kind, :string
    field :level, :string
    field :name, :string
    field :shift, :string
    belongs_to(:university, Offers.Teach.University)
    belongs_to(:campus, Offers.Teach.Campus)

    timestamps()
  end

  @doc false
  def changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :kind, :level, :shift, :campus_id])
    |> validate_required([:name, :kind, :level, :shift, :campus_id])
    |> validate_level_option(:level)
    |> validate_kind_option(:kind)
    |> validate_shift_option(:shift)
    |> assoc_constraint(:campus)
    |> get_university()
  end

  @doc false
  def update_changeset(course, attrs) do
    course
    |> cast(attrs, [:name, :kind, :level, :shift])
    |> validate_required([:name, :kind, :level, :shift])
    |> validate_level_option(:level)
    |> validate_kind_option(:kind)
    |> validate_shift_option(:shift)
  end

  defp get_university(%Ecto.Changeset{changes: %{campus_id: id}} = changeset) do
    reg = Teach.get_campus!(id)
    reg.university_id

    changeset
    |> put_change(:university_id, reg.university_id)
  end

  defp validate_level_option(changeset, field) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        value in ["Bacharelado", "Tecnólogo"] -> []
        true -> [{field, "invalid level (should be Bacharelado or Tecnólogo)"}]
      end
    end)
  end

  defp validate_kind_option(changeset, field) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        value in ["Presencial", "EaD"] -> []
        true -> [{field, "invalid kind (should be Presencial or EaD)"}]
      end
    end)
  end

  defp validate_shift_option(changeset, field) do
    validate_change(changeset, field, fn _field, value ->
      cond do
        value in ["Manhã", "Noite", "Virtual"] -> []
        true -> [{field, "invalid shift (should be Manhã, Noite or Virtual)"}]
      end
    end)
  end
end
