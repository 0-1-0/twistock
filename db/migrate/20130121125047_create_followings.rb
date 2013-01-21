class CreateFollowings < ActiveRecord::Migration
  def change
    create_table :followings do |t|
      t.references :user
      t.references :follower

      t.timestamps
    end
    add_index :followings, :user_id
    add_index :followings, :follower_id
  end
end
