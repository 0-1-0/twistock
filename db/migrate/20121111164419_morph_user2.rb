class MorphUser2 < ActiveRecord::Migration
  def change
    remove_column :users, :hour_delta_price
    remove_column :users, :share_price
    remove_column :users, :last_update
  end
end
