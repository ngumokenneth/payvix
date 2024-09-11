defmodule PayvixWeb.User.AvatarLive do
  alias Payvix.Accounts
  use PayvixWeb, :live_view

  def render(assigns) do
    ~H"""
    <form phx-change="validate" phx-submit="save" class="bg-violet-400 py-7">
      <section phx-drop-target={@uploads.avatar.ref} class="bg-violet-800 ">
        <div><.live_file_input upload={@uploads.avatar} class="my-8" /> or drag and drop here</div>
        <%= for entry <- @uploads.avatar.entries do %>
          <article>
            <figure>
              <.live_img_preview entry={entry} />
              <figcaption><%= entry.client_name %></figcaption>
            </figure>
            <progress value={entry.client_name}><%= entry.progress %></progress>
            <button type="button" phx-click="cancel-upload" phx-value-ref={entry.ref}>&times;</button>
            <%= for err <- upload_errors(@uploads.avatar, entry) do %>
              <p><% error_to_string(err) %></p>
            <% end %>
          </article>
        <% end %>

        <p class="text-blue-800 font-bold text-2xl mt-5">
          You can upload upto <%= @uploads.avatar.max_entries %> photos
        </p>
      </section>

      <.button>Upload</.button>
    </form>
    """
  end

  def mount(_params, _session, socket) do
    {:ok, socket}
  end

  def handle_params(_unsigned_params, _uri, socket) do
    {:noreply, prepare_avatar(socket)}
  end

  def handle_event("validate", _params, socket) do
    {:noreply, socket}
  end

  def handle_event("cancel-upload", %{"ref" => ref}, socket) do
    {:noreply, cancel_upload(socket, :avatar, ref)}
  end

  def handle_event("save", _params, socket) do
    case consume_uploads(socket) do
      [] ->
        {:noreply, push_navigate(socket, to: ~p"/")}

      [avatar_url | _] ->
        update_user(socket, avatar_url)
    end
  end

  defp consume_uploads(socket) do
    consume_uploaded_entries(socket, :avatar, fn %{path: path}, entry ->
      dest = upload_destination(entry)
      Path.dirname(dest) |> File.mkdir_p()
      File.cp!(path, dest)
      static_path = Path.join(~p"/uploads/", Path.basename(dest))
      {:ok, static_path(socket, static_path)}
    end)
  end

  defp upload_destination(entry) do
    Path.join(["priv", "static", "uploads"], filename(entry))
  end

  defp filename(entry) do
    "#{entry.uuid}-#{entry.client_name}"
  end

  defp prepare_avatar(socket) do
    changeset = Accounts.change_avatar()
    form = to_form(changeset)

    socket
    |> allow_upload(:avatar, accept: ~w(.jpg .jpeg), max_entries: 3)
    |> assign(:form, form)
  end

  defp update_user(socket, avatar_url) do
    current_user = socket.assigns.current_user
    attrs = %{avatar_url: avatar_url}

    case Accounts.update_user(current_user, attrs) do
      {:ok, user} ->
        {:noreply,
         socket
         |> assign(:current_user, user)
         |> push_navigate(to: ~p"/")}

      {:error, _changeset} ->
        {:noreply, socket}
    end
  end

  defp error_to_string(:too_large), do: "too large"
  defp error_to_string(:too_many_files), do: "You have selected too many files"
  defp error_to_string(:not_accepted), do: "You have selected an unacceptable file"
end
