defmodule Todoist.Repo.Migrations.CreateTodos do
  use Ecto.Migration

  def change do
    create table(:todos) do
      add :title, :string, null: false
      add :description, :string, null: true
      add :status, :string, null: false

      timestamps()
    end
  end
end
