class AddBasePriceToUser < ActiveRecord::Migration
  def change
    add_column :users, :base_price, :integer
  end
end
