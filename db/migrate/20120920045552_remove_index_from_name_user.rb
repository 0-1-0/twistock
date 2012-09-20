class RemoveIndexFromNameUser < ActiveRecord::Migration
  def up
    remove_index :users, :nameherhe
  end

  def down
  end
end
