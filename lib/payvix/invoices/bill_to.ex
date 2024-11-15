defmodule Payvix.Invoices.BillTo do
  import Ecto.Changeset
  use Ecto.Schema

  embedded_schema do
    field(:client_name, :string)
    field(:client_email, :string)
    field(:street_address, :string)
    field(:city, :string)
    field(:post_code, :string)
    field(:country, :string)
  end

  def bill_to_changeset(%Payvix.Invoices.BillTo{} = bill_to, attrs) do
    required_fields = [:client_name, :client_email, :street_address, :city, :post_code, :country]

    bill_to
    |> cast(attrs, required_fields)
    |> validate_required(required_fields)
  end
end
