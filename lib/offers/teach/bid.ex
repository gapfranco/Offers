defmodule Offers.Teach.Bid do
  use Ecto.Schema
  import Ecto.Changeset
  alias Offers.Teach

  schema "bids" do
    field :discount_percentage, :float
    field :enabled, :boolean, default: false
    field :enrollment_semester, :string
    field :full_price, :float
    field :price_with_discount, :float
    field :start_date, :string
    belongs_to(:course, Offers.Teach.Course)
    belongs_to(:university, Offers.Teach.University)
    belongs_to(:campus, Offers.Teach.Campus)

    timestamps()
  end

  @doc false
  def changeset(bid, attrs) do
    bid
    |> cast(attrs, [
      :full_price,
      :price_with_discount,
      :discount_percentage,
      :start_date,
      :enrollment_semester,
      :enabled,
      :course_id
    ])
    |> validate_required([
      :full_price,
      :price_with_discount,
      :discount_percentage,
      :start_date,
      :enrollment_semester,
      :enabled,
      :course_id
    ])
    |> get_university()
  end

  @doc false
  def update_changeset(bid, attrs) do
    bid
    |> cast(attrs, [
      :full_price,
      :price_with_discount,
      :discount_percentage,
      :start_date,
      :enrollment_semester,
      :enabled
    ])
    |> validate_required([
      :full_price,
      :price_with_discount,
      :discount_percentage,
      :start_date,
      :enrollment_semester,
      :enabled
    ])
  end

  defp get_university(%Ecto.Changeset{changes: %{course_id: id}} = changeset) do
    reg = Teach.get_course!(id)

    changeset
    |> put_change(:university_id, reg.university_id)
    |> put_change(:campus_id, reg.campus_id)
  end
end
