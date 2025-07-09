defmodule TodoistWeb.PageController do
  use TodoistWeb, :controller

  alias Todoist.Projects

  def home(conn, _params) do
    case Projects.list_projects() do
      [] ->
        # No projects exist, redirect to project creation
        redirect(conn, to: ~p"/projects/new")

      [first_project | _] ->
        # Redirect to the first project's todos
        redirect(conn, to: ~p"/#{first_project.name}/todos")
    end
  end
end
