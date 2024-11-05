defmodule PayvixWeb.User.ShowUsersLive do
  use PayvixWeb, :live_view
  alias Payvix.Accounts.User

  def render(assigns) do
    ~H"""
    <div class="overflow-x-auto drop-shadow-lg drop-shadow-gray-900">
      <table class="min-w-full bg-white border border-gray-300 ">
        <thead>
          <tr class="bg-gray-200 text-gray-600 uppercase text-sm leading-normal">
            <th class="py-3 px-6 text-left">Name</th>
            <th class="py-3 px-6 text-left">Email</th>
            <th class="py-3 px-6 text-left">UserName</th>
          </tr>
        </thead>

        <%= for user <- @users do %>
          <tbody class="text-gray-600 text-sm font-light">
            <tr class="border-b border-gray-300 hover:bg-gray-100">
              <td class="py-3 px-6"><%= user.name %></td>
              <td class="py-3 px-6"><%= user.email %></td>
              <td class="py-3 px-6"><%= user.username %></td>
            </tr>
          </tbody>
        <% end %>
      </table>
    </div>
    """
  end

  def mount(_params, _session, socket) do
    users = Payvix.Repo.all(User)
    # {:ok, assign(socket, :users, users)}
    {:ok,
     socket
     |> assign(:users, users)
     |> stream_configure(:users, dom_id: &"user-#{&1.id}")
     |> stream(:users, users)}
  end
end
