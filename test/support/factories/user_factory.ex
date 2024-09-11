defmodule Payvix.UserFactory do
  use ExMachina.Ecto, repo: Payvix.Repo

  defmacro __using__(_opts) do
    quote do
      def user_factory do
        %Payvix.Accounts.User{
          name: FakerElixir.Name.first_name(),
          username: FakerElixir.Name.last_name(),
          email: FakerElixir.Internet.email(),
          password_hash: Ecto.UUID.generate()
        }
      end
    end
  end
end
