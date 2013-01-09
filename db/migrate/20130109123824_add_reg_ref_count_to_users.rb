class AddRegRefCountToUsers < ActiveRecord::Migration
  def change
    add_column :users, :reg_ref_count, :integer, default: 0
  end
end
