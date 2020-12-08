defmodule Offers.Repo.Migrations.CreateBids do
  use Ecto.Migration

  def change do
    create table(:bids) do
      add :full_price, :float
      add :price_with_discount, :float
      add :discount_percentage, :float
      add :start_date, :string
      add :enrollment_semester, :string
      add :enabled, :boolean, default: false, null: false
      add :course_id, references(:courses, on_delete: :delete_all)
      add :university_id, references(:universities, on_delete: :delete_all)
      add :campus_id, references(:campus, on_delete: :delete_all)

      timestamps()
    end

    create index(:bids, [:course_id])
    create index(:bids, [:university_id])
    create index(:bids, [:campus_id])
  end
end
