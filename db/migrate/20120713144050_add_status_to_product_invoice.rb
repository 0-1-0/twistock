class AddStatusToProductInvoice < ActiveRecord::Migration
  def change
    add_column :product_invoices, :status, :string
  end
end
