defmodule TodoistWeb.TodoLive.Show do
  use TodoistWeb, :live_view

  alias Todoist.Projects
  alias Todoist.Todos

  @impl true
  def mount(%{"project_name" => project_name, "todo_id" => todo_id}, _session, socket) do
    project = Projects.get_project_by_title!(project_name)
    projects = Projects.list_projects()
    todo = Todos.get_todo!(todo_id)

    {:ok,
     socket
     |> assign(:page_title, "Show Todo")
     |> assign(:projects, projects)
     |> assign(:current_project, project)
     |> assign(:current_todo, todo)
     |> assign(:form, Todos.change_todo(todo) |> to_form())}
  end

  @impl true
  def handle_event("update_todo", %{"todo" => params}, socket) do
    case Todos.update_todo(socket.assigns.current_todo, params) do
      {:ok, _todo} ->
        {:noreply, socket}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
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
          Todo {@current_todo.id}
          <:subtitle>This is a todo record from your database.</:subtitle>
        </.header>

        <.simple_form for={@form} phx-change="update_todo" phx-submit="update_todo">
          <.input field={@form[:title]} type="text" label="Title" phx-debounce="blur" />
          <.input
            field={@form[:description]}
            type="text"
            label="Description (optional)"
            phx-debounce="blur"
          />
          <.input
            field={@form[:status]}
            type="select"
            label="Status"
            options={[{"Todo", :todo}, {"Doing", :doing}, {"Done", :done}]}
          />
        </.simple_form>

        <.back navigate={~p"/#{@current_project.title}/todos"}>Back to todos</.back>
      </div>
    </div>
    """
  end
end
