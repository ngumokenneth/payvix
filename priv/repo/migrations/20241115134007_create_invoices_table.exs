defmodule Payvix.Repo.Migrations.CreateInvoicesTable do
  use Ecto.Migration

  def change do
    create table(:invoices, primary_key: false) do
      add(:invoice_id, :binary_id, primary_key: true)
      add(:bill_from, :map, null: false)
      add(:bill_to, :map, null: false)
      add(:items, :map, null: false)
      add(:invoice_date, :date, null: false)
      add(:payment_term, :string, null: false)
      add(:project_description, :string, null: false)
      add(:status, :string, null: false)
      add(:user_id, references(:users, column: :user_id, type: :binary_id, on_delete: :delete_all), null: false)

      timestamps(type: :utc_datetime)
    end

    create index(:invoices, [:user_id])

    alter table(:users) do
      add(:invoices_ref_id, references(:invoices, column: :invoice_id, type: :binary_id, on_delete: :delete_all))
    end
  end
end
