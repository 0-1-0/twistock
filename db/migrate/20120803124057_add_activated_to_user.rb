class AddActivatedToUser < ActiveRecord::Migration
  def change
    add_column :users, :acivated, :boolean, :default=>false
  end
end
