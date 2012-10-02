class AddTweetCategoryToUser < ActiveRecord::Migration
  def change
    add_column :users, :tweet_category, :string
  end
end
