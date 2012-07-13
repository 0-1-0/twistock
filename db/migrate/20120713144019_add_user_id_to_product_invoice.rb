class AddUserIdToProductInvoice < ActiveRecord::Migration
  def change
    add_column :product_invoices, :user_id, :integer
  end
end
