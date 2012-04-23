class CreateTransactions < ActiveRecord::Migration
  def change
    create_table :transactions do |t|
      t.integer :user_id
      t.string :action
      t.integer :owner_id
      t.integer :count
      t.integer :cost

      t.timestamps
    end

    add_index :transactions, :action
    add_index :transactions, :user_id
  end
end
