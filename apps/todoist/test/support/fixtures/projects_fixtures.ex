defmodule Todoist.ProjectsFixtures do
  @moduledoc """
  This module defines test helpers for creating
  entities via the `Todoist.Projects` context.
  """

  @doc """
  Generate a project.
  """
  def project_fixture(attrs \\ %{}) do
    {:ok, project} =
      attrs
      |> Enum.into(%{
        description: "some description",
        title: "some title"
      })
      |> Todoist.Projects.create_project()

    project
  end
end
