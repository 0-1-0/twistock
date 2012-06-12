class AddHourDeltaPriceToUser < ActiveRecord::Migration
  def change
    add_column :users, :hour_delta_price, :integer, :default=>0

  end
end
