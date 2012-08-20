class ChangeMoneyType < ActiveRecord::Migration
  def up
    change_column :users, :share_price, :integer, :limit=>8
  end

  def down
  end
end
