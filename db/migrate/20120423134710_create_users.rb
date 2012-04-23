class CreateUsers < ActiveRecord::Migration
  def change
    create_table :users do |t|
      t.integer :uid
      t.string :name
      t.string :nickname
      t.string :avatar
      t.integer :money

      t.timestamps
    end
    
    add_index :users, :uid,       unique: true
    add_index :users, :nickname,  unique: true
    add_index :users, :name,      unique: true
  end
end
