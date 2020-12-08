defmodule Offers.Repo.Migrations.CreateCourses do
  use Ecto.Migration

  def change do
    create table(:courses) do
      add :name, :string
      add :kind, :string
      add :level, :string
      add :shift, :string
      add :campus_id, references(:campus, on_delete: :nothing)
      add :university_id, references(:universities, on_delete: :nothing)

      timestamps()
    end

    create index(:courses, [:campus_id])
    create index(:courses, [:university_id])
  end
end
