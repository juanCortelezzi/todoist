defmodule Todoist.Todos.Todo do
  use Ecto.Schema
  import Ecto.Changeset

  schema "todos" do
    field(:title, :string)
    field(:status, Ecto.Enum, values: [:todo, :doing, :done])
    field(:description, :string)

    belongs_to(:project, Todoist.Projects.Project)

    timestamps()
  end

  @doc false
  def changeset(todo, attrs) do
    todo
    |> cast(attrs, [:title, :description, :status, :project_id])
    |> validate_required([:title, :status, :project_id])
  end
end
