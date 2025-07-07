defmodule TodoistWeb.Components.ProjectSidebar do
  @moduledoc """
  Provides a sidebar component for project navigation.

  Displays a list of projects with navigation links and provides
  buttons to create new projects when the list is empty or populated.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS
  import TodoistWeb.CoreComponents

  attr :projects, :list, required: true
  attr :current_project_id, :integer, default: nil

  def project_sidebar(assigns) do
    ~H"""
    <div class="w-64 h-full bg-gray-50 border-r border-gray-200 p-4 flex-shrink-0 overflow-y-auto space-y-4">
      <h2 class="text-lg font-semibold text-gray-900">Projects</h2>
      <%= if @projects == [] do %>
        <p class="text-gray-500">No projects yet</p>
      <% end %>

      <nav class="space-y-1">
        <%= for project <- @projects do %>
          <.link
            navigate={"/#{project.title}/todos"}
            class={[
              "flex items-center p-2 rounded-lg",
              if project.id == @current_project_id do
                "bg-orange-100 text-orange-900 hover:bg-orange-200 transition-all"
              else
                "text-gray-600 hover:bg-gray-100 hover:text-gray-900"
              end
            ]}
          >
            <span class="truncate">{project.title}</span>
          </.link>
        <% end %>
      </nav>

      <.button phx-click={JS.navigate("/projects/new")} class="w-full">
        + New Project
      </.button>
    </div>
    """
  end
end
