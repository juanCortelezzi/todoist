defmodule Todoist.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      Todoist.Repo,
      {Ecto.Migrator,
        repos: Application.fetch_env!(:todoist, :ecto_repos),
        skip: skip_migrations?()},
      {DNSCluster, query: Application.get_env(:todoist, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Todoist.PubSub}
      # Start a worker by calling: Todoist.Worker.start_link(arg)
      # {Todoist.Worker, arg}
    ]

    Supervisor.start_link(children, strategy: :one_for_one, name: Todoist.Supervisor)
  end

  defp skip_migrations?() do
    # By default, sqlite migrations are run when using a release
    System.get_env("RELEASE_NAME") != nil
  end
end
