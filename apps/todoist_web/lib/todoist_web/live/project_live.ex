defmodule TodoistWeb.ProjectLive do
  use TodoistWeb, :live_view

  alias Todoist.Projects
  alias Todoist.Projects.Project

  @impl true
  def mount(_params, _session, socket) do
    projects = Projects.list_projects()
    
    {:ok, 
     socket
     |> assign(:projects, projects)
     |> assign(:page_title, "Create Project")}
  end

  @impl true
  def handle_params(params, _url, socket) do
    {:noreply, apply_action(socket, socket.assigns.live_action, params)}
  end

  defp apply_action(socket, :new, _params) do
    project = %Project{}
    socket
    |> assign(:page_title, "New Project")
    |> assign(:project, project)
    |> assign(:form, to_form(Projects.change_project(project)))
  end

  @impl true
  def handle_event("save", %{"project" => project_params}, socket) do
    case Projects.create_project(project_params) do
      {:ok, project} ->
        {:noreply,
         socket
         |> put_flash(:info, "Project created successfully")
         |> push_navigate(to: ~p"/#{project.title}/todos")}

      {:error, %Ecto.Changeset{} = changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset))}
    end
  end

  @impl true
  def handle_event("validate", %{"project" => project_params}, socket) do
    changeset = Projects.change_project(socket.assigns.project, project_params)
    {:noreply, assign(socket, :form, to_form(changeset, action: :validate))}
  end
end