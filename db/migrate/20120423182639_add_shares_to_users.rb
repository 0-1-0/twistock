class AddSharesToUsers < ActiveRecord::Migration
  def change
    add_column :users, :shares, :integer
    add_column :users, :retention_shares, :integer
  end
end
