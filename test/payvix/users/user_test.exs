defmodule Payvix.Accounts.UserTest do
  use Payvix.DataCase, async: true

  alias Payvix.Accounts.User

  describe "Accounts schema" do
    test "given the correct params, it returns a valid changeset" do
      params = %{
        "name" => "ken",
        "username" => "username",
        "email" => "random@email.com",
        "password" => "Random@12345"
      }

      %{changes: changes} = changeset = User.creation_changeset(params)
      assert changeset.valid?
      assert changes[:password_hash]
      assert changes[:name] == params["name"]
      assert changes[:username] == params["username"]
      assert changes[:email] == params["email"]

      refute changes[:password]
    end

    test "given params that do not have any of the required fields, it reurns an invalid changeset" do
      changeset = User.creation_changeset(%{})

      assert changeset.valid? == false
      assert "can't be blank" in errors_on(changeset).email
      assert "can't be blank" in errors_on(changeset).name
      assert "can't be blank" in errors_on(changeset).password
      assert "can't be blank" in errors_on(changeset).username
    end
  end
end
