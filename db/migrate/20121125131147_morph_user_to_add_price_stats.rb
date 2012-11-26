class MorphUserToAddPriceStats < ActiveRecord::Migration
  def change
    add_column :users, :daily_price_change,   :integer
    add_column :users, :weekly_price_change,  :integer
    add_column :users, :monthly_price_change, :integer
  end
end
