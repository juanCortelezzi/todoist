defmodule TodoistWeb.TodoLiveTest do
  use TodoistWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todoist.TodosFixtures
  import Todoist.ProjectsFixtures

  @create_attrs %{status: :todo, description: "Buy groceries", title: "Weekly shopping"}
  @invalid_attrs %{status: :todo, title: "", project_id: 1}

  defp create_todo(_) do
    project = project_fixture(%{name: "Test Project #{System.unique_integer()}"})
    todo = todo_fixture(%{project_id: project.id})
    %{todo: todo, project: project}
  end

  describe "Index" do
    setup [:create_todo]

    test "lists all todos", %{conn: conn, todo: todo, project: project} do
      {:ok, _index_live, html} = live(conn, ~p"/#{project.name}/todos")

      assert html =~ "#{project.name} - Todos"
      assert html =~ todo.status |> Atom.to_string()
    end

    test "saves new todo", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/#{project.name}/todos")

      assert index_live |> element("a", "New Todo") |> render_click() =~
               "New Todo"

      assert_patch(index_live, ~p"/#{project.name}/todos/new")

      assert index_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      create_attrs_with_project = Map.put(@create_attrs, :project_id, project.id)

      assert index_live
             |> form("#todo-form", todo: create_attrs_with_project)
             |> render_submit()

      assert_patch(index_live, ~p"/#{project.name}/todos")

      html = render(index_live)
      assert html =~ "Todo created successfully"
      assert html =~ "Weekly shopping"
    end

    test "deletes todo in listing", %{conn: conn, todo: todo, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/#{project.name}/todos")

      assert index_live |> element("#todos-#{todo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todos-#{todo.id}")
    end
  end

  describe "Show" do
    setup [:create_todo]

    test "displays todo", %{conn: conn, todo: todo, project: project} do
      {:ok, _show_live, html} = live(conn, ~p"/#{project.name}/todos/#{todo}")

      assert html =~ "Show Todo"
      assert html =~ todo.status |> Atom.to_string()
    end
  end
end
