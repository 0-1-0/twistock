class RemoveObsoleteUserLogic < ActiveRecord::Migration
  def up
    remove_column :users, :shares
    remove_column :users, :retention_shares
    add_column    :users, :retention_done, :boolean
  end

  def down
    add_column :users, :shares, :integer
    add_column :users, :retention_shares, :integer
    remove_column :users, :retention_done
  end
end
