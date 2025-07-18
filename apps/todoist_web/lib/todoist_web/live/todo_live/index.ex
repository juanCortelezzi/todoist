defmodule TodoistWeb.TodoLive.Index do
  use TodoistWeb, :live_view

  alias Todoist.Projects
  alias Todoist.Todos
  alias Todoist.Todos.Todo

  @impl true
  def mount(%{"project_name" => project_name}, _session, socket) do
    project = Projects.get_project_by_name!(project_name)
    projects = Projects.list_projects()
    todos = Todos.list_todos_by_project(project)

    {:ok,
     socket
     |> assign(:current_project, project)
     |> assign(:projects, projects)
     |> assign(:form, Projects.change_project(project) |> to_form())
     |> stream(:todos, todos)}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    socket
    |> assign(:page_title, "New Todo")
    |> assign(:todo, %Todo{project_id: socket.assigns.current_project.id})
  end

  defp apply_action(socket, :index, _params) do
    project = socket.assigns.current_project

    socket
    |> assign(:page_title, "#{project.name} - Todos")
    |> assign(:todo, nil)
  end

  @impl true
  def handle_info({TodoistWeb.TodoLive.FormComponent, {:saved, todo}}, socket) do
    {:noreply, stream_insert(socket, :todos, todo)}
  end

  @impl true
  def handle_event("update_project", %{"project" => params}, socket) do
    case Projects.update_project(socket.assigns.current_project, params) do
      {:ok, project} ->
        {:noreply, 
         socket
         |> assign(:current_project, project)
         |> assign(:form, Projects.change_project(project) |> to_form())
         |> push_navigate(to: ~p"/#{project.name}/todos")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("delete", %{"id" => id}, socket) do
    todo = Todos.get_todo!(id)
    {:ok, _} = Todos.delete_todo(todo)

    {:noreply, stream_delete(socket, :todos, todo)}
  end

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-full max-w-full">
      <TodoistWeb.Components.ProjectSidebar.project_sidebar
        current_project_id={@current_project.id}
        projects={@projects}
      />

      <div class="flex-1 p-4 overflow-y-auto">
        <.header>
          <.simple_form for={@form} phx-change="update_project" phx-submit="update_project">
            <.input field={@form[:name]} type="text" phx-debounce="blur" />
          </.simple_form>
          <:actions>
            <.link patch={~p"/#{@current_project.name}/todos/new"}>
              <.button>New Todo</.button>
            </.link>
          </:actions>
        </.header>

        <.table
          id="todos"
          rows={@streams.todos}
          row_click={fn {_id, todo} -> JS.navigate(~p"/#{@current_project.name}/todos/#{todo}") end}
        >
          <:col :let={{_id, todo}} label="Title">{todo.title}</:col>
          <:col :let={{_id, todo}} label="Description">{todo.description || "—"}</:col>
          <:col :let={{_id, todo}} label="Status">{todo.status}</:col>
          <:action :let={{_id, todo}}>
            <div class="sr-only">
              <.link navigate={~p"/#{@current_project.name}/todos/#{todo}"}>Show</.link>
            </div>
          </:action>
          <:action :let={{id, todo}}>
            <.link
              phx-click={JS.push("delete", value: %{id: todo.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              Delete
            </.link>
          </:action>
        </.table>
      </div>
    </div>

    <.modal
      :if={@live_action in [:new]}
      id="todo-modal"
      show
      on_cancel={JS.patch(~p"/#{@current_project.name}/todos")}
    >
      <.live_component
        module={TodoistWeb.TodoLive.FormComponent}
        id={@todo.id || :new}
        title={@page_title}
        action={@live_action}
        todo={@todo}
        patch={~p"/#{@current_project.name}/todos"}
      />
    </.modal>
    """
  end
end
