defmodule Payvix.Accounts.User do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :avatar, :string
    field :password_hash, :string
    field :password, :string, virtual: true, redact: true

    timestamps()
  end

  @doc """
  Returns a changeset for creating a user/changing a user
  """
  def creation_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:name, :username, :email, :password])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 4, max: 72)
    |> put_password_hash()
    |> unsafe_validate_unique(:email, Payvix.Repo, message: "Email already taken")
    |> unique_constraint(:email, message: "Email is already taken")
    |> unique_constraint(:username, message: "Username is already taken")
  end

  @doc """
  Returns a changeset for login
  """
  def login_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:email, :password])
    |> validate_required([:email, :password])
    |> validate_format(:email, ~r/@/)
    |> validate_length(:password, min: 4)
  end

  def update_user_changeset(user, attrs) do
    user
    |> cast(attrs, [:name, :username, :email, :password, :avatar])
    |> validate_required([:name, :username, :email, :password, :avatar])
    |> unsafe_validate_unique(:email, Payvix.Repo, message: "Email already taken")
    |> unique_constraint(:email, message: "Email is already taken")
    |> unique_constraint(:username, message: "Username is already taken")
  end

  def avatar_changeset(attrs \\ %{}) do
    %__MODULE__{}
    |> cast(attrs, [:avatar])
    |> validate_required([:avatar])
  end

  @doc """
  Checks validity of changeset
  """
  def put_password_hash(%{valid?: valid} = changeset) do
    hash = valid && get_change(changeset, :password)
    if hash, do: hash_password(changeset), else: changeset
  end

  @doc """
  Hashes a valid changeset and replace :password with :password_hash key in changeset
  """
  def hash_password(%{changes: %{password: password}} = changeset) do
    hash = Argon2.hash_pwd_salt(password)
    changeset |> put_change(:password_hash, hash) |> delete_change(:password)
  end
end
