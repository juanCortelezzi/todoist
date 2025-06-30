defmodule Todoist.Repo.Migrations.AddProjectToTodos do
  use Ecto.Migration

  def change do
    alter table(:todos) do
      add :project_id, references(:projects), null: false
    end
  end
end
