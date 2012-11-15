class CreatePriceLogs < ActiveRecord::Migration
  def change
    create_table :price_logs do |t|
      t.references :user
      t.integer :price

      t.timestamps
    end
    add_index :price_logs, :user_id
  end
end
