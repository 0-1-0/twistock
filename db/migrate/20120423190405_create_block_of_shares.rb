class CreateBlockOfShares < ActiveRecord::Migration
  def change
    create_table :block_of_shares do |t|
      t.integer :owner_id
      t.integer :holder_id
      t.integer :count

      t.timestamps
    end

    add_index :block_of_shares, :owner_id
    add_index :block_of_shares, :holder_id
  end
end
