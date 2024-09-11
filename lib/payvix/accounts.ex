defmodule Payvix.Accounts do
  @moduledoc """
  The Accounts context
  """

  alias Payvix.Accounts.User

  alias Payvix.Accounts.Query
  alias Payvix.Repo

  ## Database getters

  @doc """
  Gets a user by email.

   ## Examples

   iex> get_user_by_email("payvix@example.com")
   %User{}

   iex> get_user_by_email("unknown@example.com")
   nil
  """
  def get_user_by_email(email) when is_binary(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Get a user by email and password

  ## Examples

  iex> get_user_by_email_and_password("payvix@example.com", valid_password)
  %User{}

  iex> get_user_by_email_and_password("payvix@example.com", invalid_password)
  nil


  """

  def get_user_by_email_and_password(email, password)
      when is_binary(email) and is_binary(password) do
    user = Repo.get_by(User, email: email)
    if valid_password?(user, password), do: user
  end

  @doc """
  Get a single user

  ## Example

  iex> get_user!(123)
  %User{}

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Checks password is valid
  If there is no user or the user doesn't have a password, if there is no user we call Argon2.no_user_verify/1
  """
  def valid_password?(%User{password_hash: password_hash}, password)
      when is_binary(password_hash) and byte_size(password) > 0 do
    Argon2.verify_pass(password, password_hash)
  end

  def valid_password?(_, _) do
    Argon2.no_user_verify()
    false
  end

  ## SETTINGS
  @doc """
  Returns an %Ecto.Changeset{} for changing a user email

  ## Example
  iex> change_user_email(user)
  %Ecto.Changeset{data: %User{}}
  """

  def change_user_email(attrs \\ %{}) do
    User.creation_changeset(attrs)
  end

  def create_user(params) do
    user = User.creation_changeset(params)
    Repo.insert(user)
  end

  def change_user(params \\ %{}) do
    User.creation_changeset(params)
  end

  def change_user_for_login(params) do
    User.login_changeset(params)
  end

  def change_avatar(params \\ %{}) do
    User.avatar_changeset(params)
  end

  def create_avatar(params \\ %{}) do
    avatar = User.avatar_changeset(params)
    Repo.insert(avatar)
  end

  def update_user(user, attrs) do
    user
    |> User.update_user_changeset(attrs)
    |> Repo.update()
  end

  def login_user(%{"email" => email} = params) do
    with {:ok, user} <- user_with_email(email) do
      maybe_login_user(user, params)
    end
  end

  defp user_with_email(email) do
    query = Query.with_email(email)
    user = Repo.one(query)

    if user, do: {:ok, user}, else: {:error, :invalid_credentials}
  end

  defp maybe_login_user(user, %{"password" => password}) do
    similar? = user.password == password
    if similar?, do: {:ok, user}, else: {:error, :invalid_credentials}
  end
end
