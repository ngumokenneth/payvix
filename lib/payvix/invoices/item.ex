defmodule Payvix.Invoices.Item do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:item_name, :string)
    field(:quantity, :integer, default: 1)
    field(:price, :decimal, default: 0)
    field(:total, :decimal, default: 0)
  end

  def item_changeset(%Payvix.Invoices.Item{} = item, attrs) do
    changeset_items = [:item_name, :quantity, :price, :total]

    item
    |> cast(attrs, changeset_items)
    |> validate_required(changeset_items)
    |> calculate_total()
    |> validate_number(:price, greater_than_or_equal_to: 0)
    |> validate_number(:quantity, greater_than_or_equal_to: 1)
  end

  def calculate_total(changeset) do
    price = get_field(changeset, :price, 0)
    quantity = get_field(changeset, :quantity, 1)

    changeset |> put_change(:total, Decimal.mult(price, quantity))
  end
end
