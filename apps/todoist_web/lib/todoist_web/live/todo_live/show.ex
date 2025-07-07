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

  @impl true
  def render(assigns) do
    ~H"""
    <div class="flex h-full max-w-full">
      <TodoistWeb.Components.ProjectSidebar.project_sidebar
        current_project_id={@current_project.id}
        projects={@projects}
      />

      <div class="flex-1 min-w-0 p-8 overflow-y-auto">
        <.header>
          Todo {@todo.id}
          <:subtitle>This is a todo record from your database.</:subtitle>
          <:actions>
            <.link
              patch={~p"/#{@current_project.title}/todos/#{@todo}/show/edit"}
              phx-click={JS.push_focus()}
            >
              <.button>Edit todo</.button>
            </.link>
          </:actions>
        </.header>

        <.list>
          <:item title="Title">{@todo.title}</:item>
          <:item title="Description">{@todo.description || "No description"}</:item>
          <:item title="Status">{@todo.status}</:item>
        </.list>

        <.back navigate={~p"/#{@current_project.title}/todos"}>Back to todos</.back>
      </div>
    </div>

    <.modal
      :if={@live_action == :edit}
      id="todo-modal"
      show
      on_cancel={JS.patch(~p"/#{@current_project.title}/todos/#{@todo}")}
    >
      <.live_component
        module={TodoistWeb.TodoLive.FormComponent}
        id={@todo.id}
        title={@page_title}
        action={@live_action}
        todo={@todo}
        patch={~p"/#{@current_project.title}/todos/#{@todo}"}
      />
    </.modal>
    """
  end
end
