defmodule Payvix.Factory do
  use ExMachina.Ecto, repo: Payvix.Repo

  use Payvix.UserFactory
end
