class ChangePriceType < ActiveRecord::Migration
  def up
    change_column :users, :money, :integer, :limit=>8
  end

  def down
  end
end
