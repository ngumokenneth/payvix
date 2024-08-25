defmodule Payvix.Users do
  alias Payvix.Users.User
  alias Payvix.Repo

  def create_user(params) do
    user = User.creation_changeset(params)
    Repo.insert(user)
  end

  def change_user(attrs \\ %{}) do
    User.creation_changeset(attrs)
  end
end
