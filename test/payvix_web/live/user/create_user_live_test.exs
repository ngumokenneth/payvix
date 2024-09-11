defmodule PayvixWeb.User.CreateUserLiveTest do
  use PayvixWeb.ConnCase, async: true
  alias Payvix.Accounts
  alias Payvix.Accounts.User

  describe "user registration form" do
    setup do
      params = %{
        "email" => FakerElixir.Internet.email(),
        "username" => FakerElixir.Name.first_name(),
        "name" => FakerElixir.Name.last_name(),
        "password" => "Random@12345"
      }

      {:ok, user} = Accounts.create_user(params)
      {:ok, user: user}
    end

    test "a user can visit the page", %{conn: conn} do
      {:ok, _view, html} = live(conn, ~p"/Accounts/new")
      assert html =~ "Create an Account"
    end

    test "a user can see the registration form on visiting the page", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/Accounts/new")

      form = element(view, "#user-registration-form")
      assert has_element?(form)

      email_input = element(view, "input#user_form_email")
      assert has_element?(email_input)

      name_input = element(view, "input#user_form_name")
      assert has_element?(name_input)

      password_input = element(view, "input#user_form_password")
      assert has_element?(password_input)

      username_input = element(view, "input#user_form_username")
      assert has_element?(username_input)
    end

    test "when a user enters an email that is already taken, the user sees an error before submiting",
         %{conn: conn, user: user} do
      {:ok, view, _html} = live(conn, ~p"/Accounts/new")

      changes = %{
        "email" => user.email,
        "username" => "ken",
        "name" => "ngumo",
        "password" => "Random@123456"
      }

      form = form(view, "form#user-registration-form", %{user_form: changes})
      assert has_element?(form)

      rendered_html = render_change(form)
      assert rendered_html =~ "Email already taken"
    end

    test "a user can create a new user from the registration form", %{conn: conn} do
      {:ok, view, _html} = live(conn, ~p"/Accounts/new")

      changes = %{
        "email" => "new@email.com",
        "username" => "ken",
        "name" => "ngumo",
        "password" => "Random@123456"
      }

      form = form(view, "form#user-registration-form", %{user_form: changes})
      assert has_element?(form)

      rendered_html = render_submit(form)
      assert rendered_html =~ "User created successfully"

      query =
        where(User, [u], u.email == ^changes["email"] and u.username == ^changes["username"])

      assert Payvix.Repo.exists?(query)
    end
  end
end
