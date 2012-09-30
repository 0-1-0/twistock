class AddMissingIndexes < ActiveRecord::Migration
  def change
    add_index :product_invoices,  :product_id
    add_index :product_invoices,  :user_id
    add_index :transactions,      :owner_id
  end
end
