defmodule PayvixWeb.User.LoginUserLive do
  use PayvixWeb, :live_view

  alias Payvix.Accounts.User
  alias Payvix.Accounts

  def render(assigns) do
    ~H"""
    <h1 class="font-semibold">Sign in to Invoice</h1>
    <.simple_form for={@form} phx-change="validate" phx-submit="submit">
      <.input label="Email" field={@form[:email]} placeholder="example@gmail.com" />
      <.input label="Password" field={@form[:password]} placeholder="Enter Your Password" />

      <:actions>
        <.button>Login</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, prepare_socket(socket)}
  end

  def handle_event("validate", user_params, socket) do
    {:noreply, handle_validate(user_params, socket)}
  end

  def handle_event("submit", %{"user_form" => user_params}, socket) do
    {:noreply, handle_submit(user_params, socket)}
  end

  defp handle_validate(user_params, socket) do
    changeset = user_params |> Accounts.change_user_for_login() |> Map.put(:action, :validate)

    form = to_form(changeset, as: "user_form")
    assign(socket, :form, form)
  end

  defp handle_submit(user_params, socket) do
    case Accounts.login_user(user_params) do
      {:ok, _user} -> push_navigate(socket, to: ~p"/")
      {:error, _not_found} -> put_flash(socket, :error, "Invalid credentials")
    end
  end

  defp prepare_socket(socket) do
    changeset = User.login_changeset()
    form = to_form(changeset)
    assign(socket, :form, form)
  end
end
