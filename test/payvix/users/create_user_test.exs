defmodule Payvix.Accounts.CreateUserTest do
  use Payvix.DataCase, async: true

  alias Payvix.Accounts
  alias Payvix.Accounts.User

  describe "create a new user" do
    setup do
      params = %{
        "name" => FakerElixir.Name.last_name(),
        "username" => FakerElixir.Name.first_name(),
        "email" => FakerElixir.Internet.email(),
        "password" => "Random@12345"
      }

      {:ok, user} = Accounts.create_user(params)
      {:ok, user: user}
    end

    test "when given params of a user that does not exist, a new user is created" do
      params = %{
        "name" => FakerElixir.Name.last_name(),
        "username" => FakerElixir.Name.first_name(),
        "email" => FakerElixir.Internet.email(),
        "password" => "Random@12345"
      }

      {:ok, _user} = Accounts.create_user(params)
      query = where(User, [u], u.email == ^params["email"])
      assert Payvix.Repo.exists?(query)
    end

    test "when given invalid params where required fields are not provided, a new user is not created" do
      params = %{"email" => FakerElixir.Internet.email()}
      assert {:error, _changeset} = Accounts.create_user(params)
      query = where(User, [u], u.email == ^params["email"])
      refute Payvix.Repo.exists?(query)
    end

    test "given params with an existing email, a new user is not created and the changeset contains an error",
         %{user: user} do
      params = %{
        "email" => user.email,
        "password" => "Random@12345",
        "username" => FakerElixir.Name.first_name()
      }

      assert {:error, changeset} = Accounts.create_user(params)
      assert "Email already taken" in errors_on(changeset).email

      query = where(User, [u], u.email == ^params["email"])
      assert [_user] = Payvix.Repo.all(query)
    end

    test "given parameters with an existing username, a new user is not created and the changeset contains an error",
         %{user: user} do
      params = %{
        "username" => user.username,
        "name" => FakerElixir.Name.last_name(),
        "email" => FakerElixir.Internet.email(),
        "password" => "Random@12345"
      }

      {:error, changeset} = Accounts.create_user(params)
      assert "Username is already taken" in errors_on(changeset).username

      query = where(User, [u], u.username == ^params["username"])
      assert [_user] = Payvix.Repo.all(query)
    end
  end
end
