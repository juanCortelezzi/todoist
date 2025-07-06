defmodule TodoistWeb.TodoLive.Index do
  use TodoistWeb, :live_view

  alias Todoist.Projects
  alias Todoist.Todos
  alias Todoist.Todos.Todo

  @impl true
  def mount(%{"project_name" => project_name}, _session, socket) do
    project = Projects.get_project_by_title!(project_name)
    projects = Projects.list_projects()
    todos = Todos.list_todos_by_project(project)

    {:ok,
     socket
     |> assign(:current_project, project)
     |> assign(:projects, projects)
     |> stream(:todos, todos)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :edit, %{"id" => id}) do
    socket
    |> assign(:page_title, "Edit Todo")
    |> assign(:todo, Todos.get_todo!(id))
  end

  defp apply_action(socket, :new, _params) do
    project = socket.assigns.current_project

    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{project_id: project.id})
  end

  defp apply_action(socket, :index, _params) do
    project = socket.assigns.current_project

    socket
    |> assign(:page_title, "#{project.title} - Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_info({TodoistWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end
end
