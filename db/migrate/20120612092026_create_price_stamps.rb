class CreatePriceStamps < ActiveRecord::Migration
  def change
    create_table :price_stamps do |t|
      t.references :user
      t.integer :price

      t.timestamps
    end
    add_index :price_stamps, :user_id
  end
end
