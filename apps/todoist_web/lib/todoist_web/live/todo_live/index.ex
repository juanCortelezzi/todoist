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
    <div class="flex gap-32">
      <TodoistWeb.Components.ProjectSidebar.project_sidebar
        current_project_id={@current_project.id}
        projects={@projects}
      />

      <div class="flex-1 overflow-y-auto">
        <header class="flex items-center justify-between gap-8">
          <.form for={@form} phx-change="update_project" phx-submit="update_project">
            <TodoistWeb.Components.ImmediateInput.immediate_input
              class="header-main"
              phx-debounce="blur"
              field={@form[:name]}
            />
          </.form>
          <.link patch={~p"/#{@current_project.name}/todos/new"}>
            <.button>New Todo</.button>
          </.link>
        </header>
        <div id="todos" phx-update="stream" class="space-y-2 pt-8">
          <div
            :for={{id, todo} <- @streams.todos}
            id={id}
            class="flex items-center justify-between gap-4 p-2 rounded-lg border border-kuro"
          >
            <.link
              patch={~p"/#{@current_project.name}/todos/#{todo.id}"}
              class="flex flex-1 gap-4 items-center"
            >
              <div class={[
                "size-5 rounded-full",
                todo.status === :todo && "bg-ishi",
                todo.status === :doing && "bg-coral",
                todo.status === :done && "bg-kelp"
              ]} />
              <span>{todo.title}</span>
            </.link>
            <.link
              phx-click={JS.push("delete", value: %{id: todo.id}) |> hide("##{id}")}
              data-confirm="Are you sure?"
            >
              <.icon name="hero-trash" />
            </.link>
          </div>
        </div>
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
