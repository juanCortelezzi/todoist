defmodule Todoist.Projects.Project do
  @moduledoc """
  Defines the Project schema and changeset.

  A Project represents a container for todos with a name and description.
  Projects have many todos through a one-to-many relationship.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "projects" do
    field :description, :string
    field :name, :string

    has_many(:todos, Todoist.Todos.Todo)

    timestamps()
  end

  @doc false
  def changeset(project, attrs) do
    project
    |> cast(attrs, [:name, :description])
    |> validate_required([:name, :description])
  end
end
