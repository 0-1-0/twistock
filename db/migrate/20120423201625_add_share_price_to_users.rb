class AddSharePriceToUsers < ActiveRecord::Migration
  def change
    add_column :users, :share_price, :integer
  end
end
