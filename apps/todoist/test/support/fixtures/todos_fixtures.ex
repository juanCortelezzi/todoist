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
        title: "some title",
        status: :todo,
        description: "some description"
      })
      |> Todoist.Todos.create_todo()

    todo
  end
end
