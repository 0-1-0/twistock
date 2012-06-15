class AddPriceToTransaction < ActiveRecord::Migration
  def change
    add_column :transactions, :price, :integer, :default=>0
  end
end
