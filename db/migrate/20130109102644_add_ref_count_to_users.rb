class AddRefCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :ref_count, :integer, default: 0
  end
end
