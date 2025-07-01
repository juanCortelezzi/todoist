# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#
# Inside the script, you can read and write to any of your
# repositories directly:
#
#     Todoist.Repo.insert!(%Todoist.SomeSchema{})
#
# We recommend using the bang functions (`insert!`, `update!`
# and so on) as they will fail if something goes wrong.

alias Todoist.Repo
alias Todoist.Projects.Project
alias Todoist.Todos.Todo

# Create sample projects
work_project = Repo.insert!(%Project{
  title: "Work",
  description: "Work-related tasks and projects"
})

personal_project = Repo.insert!(%Project{
  title: "Personal",
  description: "Personal tasks and goals"
})

# Create sample todos for Work project
Repo.insert!(%Todo{
  title: "Complete project documentation",
  description: "Write comprehensive documentation for the new feature",
  status: :todo,
  project_id: work_project.id
})

Repo.insert!(%Todo{
  title: "Review pull requests",
  description: "Review and merge pending pull requests",
  status: :doing,
  project_id: work_project.id
})

# Create sample todos for Personal project  
Repo.insert!(%Todo{
  title: "Learn Elixir",
  description: "Complete the Elixir programming course",
  status: :doing,
  project_id: personal_project.id
})

Repo.insert!(%Todo{
  title: "Exercise routine",
  description: "Start daily exercise routine",
  status: :todo,
  project_id: personal_project.id
})
