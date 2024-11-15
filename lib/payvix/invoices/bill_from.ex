defmodule Payvix.Invoices.BillFrom do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:street_address, :string)
    field(:city, :string)
    field(:post_code, :string)
    field(:coutry, :string)
  end

  def bill_from_changeset(%Payvix.Invoices.BillFrom{} = bill_from, attrs) do
    required_fields = [:street_address, :city, :post_code, :country]

    bill_from
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
