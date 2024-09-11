defmodule Payvix.Repo.Migrations.CreateAccountsTable do
  use Ecto.Migration

  def change do
    create table("Accounts", primary_key: false) do
      add(:id, :binary_id, primary_key: true)
      add(:name, :string, null: false)
      add(:username, :string, null: false)
      add(:email, :string, null: false)
      add(:password_hash, :text, null: false)

      timestamps()
    end

    create unique_index(:Accounts, [:email])
    create unique_index(:Accounts, [:username])
  end
end
