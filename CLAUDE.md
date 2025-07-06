# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Project Architecture

This is a Phoenix Umbrella Application for a task management system built with Elixir/Phoenix. The umbrella structure separates concerns:

- `/apps/todoist/` - Core business logic, Ecto schemas, and data contexts
- `/apps/todoist_web/` - Phoenix web interface with LiveView components
- `/squeel/` - SQLite database files

## Key Technologies

- **Backend:** Elixir 1.14+, Phoenix 1.7.21, Ecto with SQLite
- **Frontend:** Phoenix LiveView, Tailwind CSS, Heroicons
- **Database:** SQLite (files in `/squeel/` directory)

## Data Model

- **Todos:** Tasks with title, description, status enum (:todo, :doing, :done)
- **Projects:** Containers for todos with one-to-many relationship
- All entities use Ecto schemas with proper validations

## Common Development Commands

```bash
# Initial setup
mix setup                    # Install deps, setup database, build assets

# Development server
mix phx.server              # Start server on localhost:4000

# Database management
mix ecto.migrate            # Run pending migrations
mix ecto.reset              # Drop and recreate database with seeds

# Asset management
mix assets.build            # Build Tailwind CSS and JavaScript
mix assets.deploy           # Build and minify assets for production

# Testing
mix test                    # Run full test suite

# Linting
mix credo --strict          # Lint all files in codebase
```

## Web Interface Architecture

The application uses Phoenix LiveView for real-time interactivity without JavaScript:

- Main routes: `/`, `/todos/*` for CRUD operations
- LiveView modules in `/apps/todoist_web/lib/todoist_web/live/`
- Shared components in `/apps/todoist_web/lib/todoist_web/components/`
- Tailwind CSS with custom brand color (#FD4F00)

## Development Environment

- LiveDashboard available at `/dev/dashboard` in development
- Live reload watches `.ex`, `.heex`, `.css`, `.js` files
- Asset watchers for Tailwind CSS and esbuild automatically compile changes
- Database uses SQL sandbox for test isolation

## Testing Structure

- ExUnit framework with Ecto SQL sandbox
- Test fixtures for projects and todos in test support files
- LiveView testing with Floki for DOM assertions
- Separate test database (`todoist_test.db`)

