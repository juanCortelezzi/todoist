defmodule Todoist.Todos.Todo do
  @moduledoc """
  Defines the Todo schema and changeset.

  A Todo represents a task that belongs to a project with a title,
  optional description, and a status that can be :todo, :doing, or :done.
  """
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
