class AddPopularityToUsers < ActiveRecord::Migration
  def change
    add_column :users, :popularity, :integer
  end
end
