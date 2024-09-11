defmodule Payvix.Accounts.Query do
  import Ecto.Query

  alias Payvix.Accounts.User

  def base, do: User

  def with_email(query \\ base(), email) do
    where(query, [u], u.email == ^email)
  end
end
