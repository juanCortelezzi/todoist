defmodule TodoistWeb.PageControllerTest do
  use TodoistWeb.ConnCase

  test "GET /", %{conn: conn} do
    conn = get(conn, ~p"/")
    assert redirected_to(conn, 302) == "/projects/new"
  end
end
