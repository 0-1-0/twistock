class AddProductIdToProductInvoice < ActiveRecord::Migration
  def change
    add_column :product_invoices, :product_id, :integer
  end
end
