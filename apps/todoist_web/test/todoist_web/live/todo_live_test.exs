defmodule TodoistWeb.TodoLiveTest do
  use TodoistWeb.ConnCase

  import Phoenix.LiveViewTest
  import Todoist.TodosFixtures
  import Todoist.ProjectsFixtures

  @create_attrs %{status: "Todo", description: "some description", title: "some title"}
  @update_attrs %{
    status: "Done",
    description: "some updated description",
    title: "some updated title"
  }
  @invalid_attrs %{status: "Todo", description: "", title: "", project_id: 1}

  defp create_todo(_) do
    todo = todo_fixture()
    project = project_fixture()
    %{todo: todo, project: project}
  end

  describe "Index" do
    setup [:create_todo]

    test "lists all todos", %{conn: conn, todo: todo} do
      {:ok, _index_live, html} = live(conn, ~p"/todos")

      assert html =~ "Listing Todos"
      assert html =~ todo.status |> Atom.to_string()
    end

    test "saves new todo", %{conn: conn, project: project} do
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("a", "New Todo") |> render_click() =~
               "New Todo"

      assert_patch(index_live, ~p"/todos/new")

      assert index_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      create_attrs_with_project = Map.put(@create_attrs, :project_id, project.id)

      assert index_live
             |> form("#todo-form", todo: create_attrs_with_project)
             |> render_submit()

      assert_patch(index_live, ~p"/todos")

      html = render(index_live)
      assert html =~ "Todo created successfully"
      assert html =~ "todo"
    end

    test "updates todo in listing", %{conn: conn, todo: todo} do
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("#todos-#{todo.id} a", "Edit") |> render_click() =~
               "Edit Todo"

      assert_patch(index_live, ~p"/todos/#{todo}/edit")

      assert index_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert index_live
             |> form("#todo-form", todo: @update_attrs)
             |> render_submit()

      assert_patch(index_live, ~p"/todos")

      html = render(index_live)
      assert html =~ "Todo updated successfully"
      assert html =~ "done"
    end

    test "deletes todo in listing", %{conn: conn, todo: todo} do
      {:ok, index_live, _html} = live(conn, ~p"/todos")

      assert index_live |> element("#todos-#{todo.id} a", "Delete") |> render_click()
      refute has_element?(index_live, "#todos-#{todo.id}")
    end
  end

  describe "Show" do
    setup [:create_todo]

    test "displays todo", %{conn: conn, todo: todo} do
      {:ok, _show_live, html} = live(conn, ~p"/todos/#{todo}")

      assert html =~ "Show Todo"
      assert html =~ todo.status |> Atom.to_string()
    end

    test "updates todo within modal", %{conn: conn, todo: todo} do
      {:ok, show_live, _html} = live(conn, ~p"/todos/#{todo}")

      assert show_live |> element("a", "Edit") |> render_click() =~
               "Edit Todo"

      assert_patch(show_live, ~p"/todos/#{todo}/show/edit")

      assert show_live
             |> form("#todo-form", todo: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert show_live
             |> form("#todo-form", todo: @update_attrs)
             |> render_submit()

      assert_patch(show_live, ~p"/todos/#{todo}")

      html = render(show_live)
      assert html =~ "Todo updated successfully"
      assert html =~ "done"
    end
  end
end
