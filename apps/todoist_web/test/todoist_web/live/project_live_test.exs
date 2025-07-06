defmodule TodoistWeb.ProjectLiveTest do
  use TodoistWeb.ConnCase

  import Phoenix.LiveViewTest

  @create_attrs %{title: "Test Project", description: "A test project"}
  @invalid_attrs %{title: "", description: "some description"}

  describe "New" do
    test "saves new project", %{conn: conn} do
      {:ok, new_live, _html} = live(conn, ~p"/projects/new")

      assert new_live
             |> form("#project-form", project: @invalid_attrs)
             |> render_change() =~ "can&#39;t be blank"

      assert new_live
             |> form("#project-form", project: @create_attrs)
             |> render_submit()

      assert_redirected(new_live, ~p"/#{@create_attrs.title}/todos")
    end

    test "displays new project form", %{conn: conn} do
      {:ok, _new_live, html} = live(conn, ~p"/projects/new")

      assert html =~ "New Project"
      assert html =~ "Title"
      assert html =~ "Description"
    end
  end
end
