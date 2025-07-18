defmodule Todoist.Repo.Migrations.CreateProjects do
  use Ecto.Migration

  def change do
    create table(:projects) do
      add :name, :string, null: false
      add :description, :string, null: false

      timestamps()
    end
  end
end
