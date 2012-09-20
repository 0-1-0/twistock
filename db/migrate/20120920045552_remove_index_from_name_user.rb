class RemoveIndexFromNameUser < ActiveRecord::Migration
  def up
    remove_index :users, :name
  end

  def down
  end
end
