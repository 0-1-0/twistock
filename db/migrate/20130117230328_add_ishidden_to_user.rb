class AddIshiddenToUser < ActiveRecord::Migration
  def change
    add_column :users, :is_hidden, :boolean, default: false
  end
end
