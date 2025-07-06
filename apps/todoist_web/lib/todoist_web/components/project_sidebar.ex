defmodule TodoistWeb.Components.ProjectSidebar do
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import TodoistWeb.CoreComponents

  attr :current_project, :string, required: true
  attr :projects, :list, required: true

  def project_sidebar(assigns) do
    ~H"""
    <div class="w-64 h-full bg-gray-50 border-r border-gray-200 p-4 flex-shrink-0 overflow-y-auto">
      <h2 class="text-lg font-semibold text-gray-900 mb-4">Projects</h2>

      <%= if @projects == [] do %>
        <div class="space-y-4">
          <p class="text-sm text-gray-500">No projects yet</p>
          <.button phx-click={JS.navigate("/projects/new")} class="w-full">
            Create Project
          </.button>
        </div>
      <% else %>
        <nav class="space-y-1">
          <%= for project <- @projects do %>
            <.link
              navigate={"/#{project.title}/todos"}
              class={[
                "group flex items-center px-2 py-2 text-sm font-medium rounded-md",
                if project.title == @current_project do
                  "bg-orange-100 text-orange-900"
                else
                  "text-gray-600 hover:bg-gray-50 hover:text-gray-900"
                end
              ]}
            >
              <div class="flex-1 min-w-0">
                <span class="truncate">{project.title}</span>
              </div>
            </.link>
          <% end %>

          <div class="mb-4">
            <.button phx-click={JS.navigate("/projects/new")} class="w-full">
              + New Project
            </.button>
          </div>
        </nav>
      <% end %>
    </div>
    """
  end
end
