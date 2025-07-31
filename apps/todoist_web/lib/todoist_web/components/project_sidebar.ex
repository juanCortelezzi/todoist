defmodule TodoistWeb.Components.ProjectSidebar do
  @moduledoc """
  Provides a sidebar component for project navigation.

  Displays a list of projects with navigation links and provides
  buttons to create new projects when the list is empty or populated.
  """
  use Phoenix.Component

  alias Phoenix.LiveView.JS

  attr :projects, :list, required: true
  attr :current_project_id, :integer, default: nil
  attr :class, :string, default: nil

  def project_sidebar(assigns) do
    ~H"""
    <div class={["h-full flex-shrink-0 overflow-y-auto space-y-8", @class]}>
      <header>
        <a href="/" class="header-functional">
          Todoist
        </a>
      </header>
      <nav class="space-y-2 flex flex-col">
        <%= if @projects == [] do %>
          <p>No projects yet</p>
        <% else %>
          <%= for project <- @projects do %>
            <.link
              navigate={"/#{project.name}/todos"}
              class={[
                if project.id == @current_project_id do
                  "underline decoration-aubergine underline-offset-2 decoration-2"
                end
              ]}
            >
              <span class="truncate">{project.name}</span>
            </.link>
          <% end %>
        <% end %>
      </nav>

      <button phx-click={JS.navigate("/projects/new")} class="w-full">
        + New Project
      </button>
    </div>
    """
  end
end
