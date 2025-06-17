defmodule Todoist.TodosFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todoist.Todos` context.
  """

  @doc """
  Generate a todo.
  """
  def todo_fixture(attrs \\ %{}) do
    {:ok, todo} =
      attrs
      |> Enum.into(%{
        description: "some description",
        status: "some status",
        title: "some title"
      })
      |> Todoist.Todos.create_todo()

    todo
  end
end
