defmodule Payvix.Invoices.Invoice do
  use Ecto.Schema
  import Ecto.Changeset

  alias Payvix.Invoices.BillFrom
  alias Payvix.Invoices.BillTo
  alias Payvix.Invoices.Item

  @valid_terms [1, 7, 14, 21, 30]

  @primary_key {:invoice_id, :binary_id, autogenerate: true}
  schema "invoices" do
    embeds_one(:bill_from, BillFrom, on_replace: :update)
    embeds_one(:bill_to, BillTo, on_replace: :update)
    embeds_many(:items, Item, on_replace: :delete)
    field(:status, Ecto.Enum, values: [:paid, :pending, :draft], default: :pending)
    field(:invoice_date, :date)
    field(:payment_term, :integer)
    field(:project_description, :string)
    belongs_to(:user, User, on_replace: :update)

    timestamps(type: :utc_datetime)
  end

  def invoice_creation_changeset(%Payvix.Invoices.Invoice{} = invoice, attrs) do
    required_fields = [:status, :invoice_date, :payment_term, :project_description]

    invoice
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
    |> validate_inclusion(:payment_term, @valid_terms)
    |> assoc_constraint(:user)
    |> cast_embed(:bill_form, with: &BillFrom.bill_from_changeset/2, required: true)
    |> cast_embed(:bill_to, with: &BillTo.bill_to_changeset/2, required: true)
    |> cast_embed(:items, with: &Item.item_changeset/2, required: true)
  end
end
