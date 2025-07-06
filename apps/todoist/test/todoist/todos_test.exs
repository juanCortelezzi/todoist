defmodule Todoist.TodosTest do
  use Todoist.DataCase

  alias Todoist.Todos

  describe "todos" do
    alias Todoist.Todos.Todo

    import Todoist.TodosFixtures
    import Todoist.ProjectsFixtures

    @invalid_attrs %{status: nil, title: nil, project_id: nil}

    test "list_todos/0 returns all todos" do
      todo = todo_fixture()
      assert Todos.list_todos() == [todo]
    end

    test "get_todo!/1 returns the todo with given id" do
      todo = todo_fixture()
      assert Todos.get_todo!(todo.id) == todo
    end

    test "create_todo/1 with valid data creates a todo" do
      project = project_fixture()

      valid_attrs = %{
        status: :done,
        description: "some description",
        title: "some title",
        project_id: project.id
      }

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.status == :done
      assert todo.description == "some description"
      assert todo.title == "some title"
      assert todo.project_id == project.id
    end

    test "create_todo/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(@invalid_attrs)
    end

    test "create_todo/1 without project_id returns error changeset" do
      attrs_without_project = %{
        status: :todo,
        description: "some description",
        title: "some title"
      }

      assert {:error, %Ecto.Changeset{}} = Todos.create_todo(attrs_without_project)
    end

    test "create_todo/1 without description creates a todo" do
      project = project_fixture()
      valid_attrs = %{status: :todo, title: "some title", project_id: project.id}

      assert {:ok, %Todo{} = todo} = Todos.create_todo(valid_attrs)
      assert todo.status == :todo
      assert todo.description == nil
      assert todo.title == "some title"
      assert todo.project_id == project.id
    end

    test "update_todo/2 with valid data updates the todo" do
      todo = todo_fixture()

      update_attrs = %{
        status: :doing,
        description: "some updated description",
        title: "some updated title"
      }

      assert {:ok, %Todo{} = todo} = Todos.update_todo(todo, update_attrs)
      assert todo.status == :doing
      assert todo.description == "some updated description"
      assert todo.title == "some updated title"
    end

    test "update_todo/2 with invalid data returns error changeset" do
      todo = todo_fixture()
      assert {:error, %Ecto.Changeset{}} = Todos.update_todo(todo, @invalid_attrs)
      assert todo == Todos.get_todo!(todo.id)
    end

    test "delete_todo/1 deletes the todo" do
      todo = todo_fixture()
      assert {:ok, %Todo{}} = Todos.delete_todo(todo)
      assert_raise Ecto.NoResultsError, fn -> Todos.get_todo!(todo.id) end
    end

    test "change_todo/1 returns a todo changeset" do
      todo = todo_fixture()
      assert %Ecto.Changeset{} = Todos.change_todo(todo)
    end
  end
end
