class CreatePostComments < ActiveRecord::Migration
  def change
    create_table :post_comments do |t|
      t.text :content
      t.references :user
      t.references :blog_post

      t.timestamps
    end
    add_index :post_comments, :user_id
    add_index :post_comments, :blog_post_id
  end
end
