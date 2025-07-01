defmodule TodoistWeb.Components.ProjectSidebar do
  use Phoenix.Component

  attr :current_project, :string, required: true
  attr :projects, :list, required: true

  def project_sidebar(assigns) do
    ~H"""
    <div class="w-64 h-full bg-gray-50 border-r border-gray-200 p-4 flex-shrink-0 overflow-y-auto">
      <h2 class="text-lg font-semibold text-gray-900 mb-4">Projects</h2>
      
      <%= if @projects == [] do %>
        <div class="space-y-4">
          <p class="text-sm text-gray-500">No projects yet</p>
          <.link 
            navigate="/projects/new" 
            class="inline-flex items-center px-3 py-2 border border-transparent text-sm leading-4 font-medium rounded-md text-white bg-orange-600 hover:bg-orange-700 focus:outline-none focus:ring-2 focus:ring-offset-2 focus:ring-orange-500"
          >
            Create Project
          </.link>
        </div>
      <% else %>
        <nav class="space-y-1">
          <div class="mb-4">
            <.link 
              navigate="/projects/new" 
              class="inline-flex items-center px-2 py-1 text-xs font-medium rounded text-orange-600 bg-orange-100 hover:bg-orange-200"
            >
              + New Project
            </.link>
          </div>
          
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
                <span class="truncate"><%= project.title %></span>
              </div>
            </.link>
          <% end %>
        </nav>
      <% end %>
    </div>
    """
  end
end