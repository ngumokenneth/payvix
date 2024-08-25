defmodule PayvixWeb.User.CreateUserLive do
  use PayvixWeb, :live_view

  alias Payvix.Users

  def render(assigns) do
    ~H"""
    <h1 class="text-[2rem] font-bold">Create an Account</h1>
    <p class="text-[#343434] font-semibold">Begin creating invoices for free!</p>
    <.simple_form for={@form} phx-change="validate" phx-submit="submit">
      <.input field={@form[:name]} label="Name" />
      <.input field={@form[:username]} label="Username" />
      <.input field={@form[:email]} label="Email" />
      <.input field={@form[:password]} label="Password" />

      <:actions>
        <.button>Submit</.button>
      </:actions>
    </.simple_form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(params, _url, %{assigns: %{live_action: action}} = socket) do
    {:noreply, apply_action(action, params, socket)}
  end

  def handle_event("validate", %{"user_form" => user_params}, socket) do
    changeset = Users.change_user(user_params)
    form = to_form(changeset, as: "user_form")
    {:noreply, assign(socket, :form, form)}
  end

  def handle_event("submit", %{"user_form" => user_params}, socket) do
    case Users.create_user(user_params) do
      {:ok, changeset} ->
        IO.inspect(changeset, label: "submit changeset ====")

        {:noreply,
         socket
         |> put_flash(:info, "User created successfully")
         |> push_navigate(to: ~p"/")}

      {:error, changeset} ->
        {:noreply, assign(socket, :form, to_form(changeset, as: "user_form"))}
    end
  end

  defp apply_action(:new, _params, socket) do
    changeset = Users.change_user()
    form = to_form(changeset, as: "user_form")
    assign(socket, :form, form)
  end
end
