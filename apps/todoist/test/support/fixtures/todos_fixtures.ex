defmodule Todoist.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todoist.Todos` context.
  """

  import Todoist.ProjectsFixtures

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    project = project_fixture()

    {:ok, todo} =
      attrs
      |> Enum.into(%{
        title: "some title",
        status: :todo,
        description: "some description",
        project_id: project.id
      })
      |> Todoist.Todos.create_todo()

    todo
  end
end
