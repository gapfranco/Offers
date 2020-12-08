defmodule Offers.Repo.Migrations.CreateCampus do
  use Ecto.Migration

  def change do
    create table(:campus) do
      add :name, :string
      add :city, :string
      add :university_id, references(:universities, on_delete: :delete_all)

      timestamps()
    end

    create index(:campus, [:university_id])
  end
end
