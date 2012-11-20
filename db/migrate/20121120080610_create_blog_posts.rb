class CreateBlogPosts < ActiveRecord::Migration
  def change
    create_table :blog_posts do |t|
      t.text :content
      t.references :user
      t.string :title
      t.boolean :published, :default=>false

      t.timestamps
    end
  end
end
