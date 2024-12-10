defmodule PayvixWeb.Invoices.InvoicesLive do
  use PayvixWeb, :live_view

  alias Payvix.Invoices.Invoice

  def mount(_params, _session, socket) do
    invoices = Payvix.Repo.all(Invoice)

    {:ok,
     socket
     |> stream_configure(:invoices, dom_id: &"invoice-#{&1.id}")
     |> stream(:invoices, invoices)}
  end

  def handle_params(params, _url, %{assigns: %{live_action: action}} = socket) do
    {:noreply, apply_action(action, params, socket)}
  end

  defp apply_action(:index, _params, socket) do
    socket
    |> assign(page_title: "listing invoices")
    |> assign(:invoice, nil)
  end
end
