# priv/repo/seeds.exs
# Script for populating the database. You can run it as:
#
#     mix run priv/repo/seeds.exs
#

alias RCTMS.Accounts
alias RCTMS.Projects
alias RCTMS.Tasks

# Create users
{:ok, user1} = Accounts.create_user(%{
  email: "user1@example.com",
  username: "user1",
  password: "password123"
})

{:ok, user2} = Accounts.create_user(%{
  email: "user2@example.com",
  username: "user2",
  password: "password123"
})

# Create projects
{:ok, project1} = Projects.create_project(%{
  name: "Project 1",
  description: "This is the first project",
  owner_id: user1.id
})

# Create tasks
{:ok, _task1} = Tasks.create_task(%{
  title: "Task 1",
  description: "This is the first task",
  status: "pending",
  priority: "high",
  project_id: project1.id,
  creator_id: user1.id,
  assignee_id: user2.id
})

{:ok, _task2} = Tasks.create_task(%{
  title: "Task 2",
  description: "This is the second task",
  status: "in_progress",
  priority: "medium",
  project_id: project1.id,
  creator_id: user1.id
})

IO.puts "Database seeded successfully!"
