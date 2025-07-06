defmodule TodoistWeb.TodoLive.Show do
  use TodoistWeb, :live_view

  alias Todoist.Projects
  alias Todoist.Todos

  @impl true
  def mount(%{"project_name" => project_name}, _session, socket) do
    project = Projects.get_project_by_title!(project_name)
    projects = Projects.list_projects()

    {:ok,
     socket
     |> assign(:current_project, project)
     |> assign(:projects, projects)}
  end

  @impl true
  def handle_params(%{"id" => id}, _, socket) do
    {:noreply,
     socket
     |> assign(:page_title, page_title(socket.assigns.live_action))
     |> assign(:todo, Todos.get_todo!(id))}
  end

  defp page_title(:show), do: "Show Todo"
  defp page_title(:edit), do: "Edit Todo"
end
