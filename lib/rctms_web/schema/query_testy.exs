defmodule RCTMSWeb.Schema.QueryTest do
  use RCTMSWeb.ConnCase

  # Import necessary test helpers
  import RCTMS.AccountsFixtures

  # Setup authentication helper
  setup %{conn: conn} do
    user = user_fixture()
    {:ok, token, _claims} = RCTMS.Accounts.Guardian.encode_and_sign(user)

    conn =
      conn
      |> put_req_header("authorization", "Bearer #{token}")
      |> put_req_header("content-type", "application/json")

    {:ok, conn: conn, user: user}
  end

  describe "users query" do
    test "me returns current user", %{conn: conn, user: user} do
      query = """
      {
        me {
          id
          username
          email
        }
      }
      """

      conn = post(conn, "/api/graphql", %{query: query})

      assert json_response(conn, 200)["data"]["me"]["id"] == to_string(user.id)
      assert json_response(conn, 200)["data"]["me"]["username"] == user.username
      assert json_response(conn, 200)["data"]["me"]["email"] == user.email
    end
  end

  describe "projects query" do
    setup [:create_project]

    test "get project by id", %{conn: conn, project: project} do
      query = """
      {
        project(id: "#{project.id}") {
          id
          name
          description
        }
      }
      """

      conn = post(conn, "/api/graphql", %{query: query})

      assert json_response(conn, 200)["data"]["project"]["id"] == to_string(project.id)
      assert json_response(conn, 200)["data"]["project"]["name"] == project.name
    end
  end

  # Helper function to create a project for testing
  defp create_project(%{user: user}) do
    project = RCTMS.Projects.create_project(%{
      name: "Test Project",
      description: "A test project",
      owner_id: user.id
    }) |> elem(1)

    %{project: project}
  end
end
