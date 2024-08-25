defmodule Payvix.Users.User do
  use Ecto.Schema

  import Ecto.Changeset

  @primary_key {:id, :binary_id, autogenerate: true}
  schema "users" do
    field :name, :string
    field :username, :string
    field :email, :string
    field :password_hash, :string
    field :password, :string, virtual: true, redact: true

    timestamps()
  end

  def creation_changeset(attrs) do
    %__MODULE__{}
    |> cast(attrs, [:name, :username, :email, :password])
    |> validate_required([:name, :username, :email, :password])
    |> validate_length(:password, min: 8, max: 72)
    |> put_password_hash()
    |> unsafe_validate_unique(:email, Payvix.Repo, message: "Email already taken")
    |> unique_constraint(:email, message: "Email is already taken")
    |> unique_constraint(:username, message: "Username is already taken")
  end

  def put_password_hash(%{valid?: valid} = changeset) do
    hash = valid && get_change(changeset, :password)
    if hash, do: hash_password(changeset), else: changeset
  end

  def hash_password(%{changes: %{password: password}} = changeset) do
    hash = Argon2.hash_pwd_salt(password)
    changeset |> put_change(:password_hash, hash) |> delete_change(:password)
  end
end
